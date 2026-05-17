# PoliceEMSActivity

This resource shows **map blips for other on-duty emergency staff** (police, sheriff, EMS, etc.): each eligible player gets a labelled blip that updates as they move, so responders can see each other while clocked in. It ships with the same **EmergencyBlips** idea as the original script (server tracks who is active, clients draw everyone else’s blip).

## How this script works

- You define which **jobs** count as emergency roles in `config.lua` (`Config.Jobs`). Each entry sets the **text prefix** on the blip and its **colour**.
- A player is added to the shared blip pool only when their **Qbox job** matches one of those entries **and** they are **on duty** in the framework (`job.onduty`). Going off duty, switching to a job that is not listed, or logging out removes them.
- **`/cops`** prints who is currently in that pool (useful for a quick check; blips on the map only show **other** people, not yourself.)
- **Discord** is optional: you can put a **webhook URL** per job to log when someone enters or leaves the blip pool. If you leave webhooks as `nil`, nothing is sent.

## How this differs from the original (JaredScar / Badger version)

| Original | This version |
|----------|----------------|
| Access gated by **Discord roles** via **Badger_Discord_API** | No Discord roles; uses **Qbox (`qbx_core`)** job name + **framework duty** |
| Players ran **`/duty`** to toggle their own emergency blip (and got a **weapon loadout** when toggling on) | No **`/duty`** or **`/bliptag`**: duty is whatever your server already uses (menus, toggles, etc.); **no automatic weapons or armour** |
| Config was a **role ID → blip tag/colour** list | Config is **`job` name → tag/colour/webhook** (must match `qbx_core` jobs) |
| Registered players on **spawn** with Discord | Registers/syncs on **player loaded**, **duty change**, and **job update** Qbox events |

The upstream project and older docs (e.g. Badger) still describe Discord registration and the original commands; treat those as **not applicable** here unless you run the unmodified script.

**Requires** `qbx_core` started before this resource.
