** It is not mandatory—nor is it expected—for this pod to be continuously in a `Running` state.**

`system-searchd-manticore-reindex` is spawned by a Kubernetes **Job or CronJob**, not a long-running Deployment or DaemonSet. Its intended lifecycle is to spin up, perform a batch reindexing task, and exit.

---

### 1. Job Pod Behavior vs. Long-Running Pods

* **`system-searchd`** is the search server daemon (Manticore/Sphinx search backend for the 3scale `system` component). That pod **must** stay in the `Running` state.
* **`system-searchd-manticore-reindex-*`** is a one-off batch task that runs indexer utilities (such as rebuilding or updating search indexes from the MySQL/PostgreSQL database into Manticore storage). Once finished, its desired terminal state is **`Completed`** (Exit Code `0`).

---

### 2. Does an `Error` Impact Your Setup?

While it should not stay running, **finishing in an `Error` state (Exit Code != 0) means the reindexing process failed.**

* **API Gateway Traffic:** Core traffic (APICast, Envoy, backend-listener, and rate-limiting) is unaffected. APIs will continue routing requests.
* **3scale Admin Portal:** Search functionality inside the 3scale Admin UI (searching for accounts, applications, developers, forum posts, or documentation) will be degraded, stale, or return empty/inaccurate results until a reindex succeeds.

---

### 3. How to Diagnose and Resolve the Error

Inspect the logs of the failed pod to see the exact root cause:

```bash
# Check the pod logs
oc logs <pod-name> -n <3scale-namespace>
# or
kubectl logs <pod-name> -n <3scale-namespace>

```

Common causes include:

1. **Database Not Ready or Locked:** The reindex job started before `system-mysql` (or `system-postgresql`) finished migrations or became reachable.
2. **Shared Storage / Lock Contention:** If `system-searchd` is actively locking the index files on its persistent volume (`system-searchd-pvc`), the indexing process might fail to write new index binary files.
3. **Out of Memory (OOMKilled):** If the database has a large number of entities, the indexer process may exceed its container memory limit. Check `kubectl describe pod <pod-name>` for `OOMKilled: true`.

Once the root cause is resolved, you can trigger a clean re-run by deleting the failed job pod or triggering the job again:

```bash
kubectl delete pod <pod-name> -n <3scale-namespace>

```
