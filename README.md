# claude code sandbox

This is a docker compose based setup to run claude code in an isolated environment. It achieves the following:

## Isolation

### Isolated file system

Claude can only access what you put in ./workspace, which is mounted in as a volume. Because it is in a container, it cannot access anything else on your host.

### Isolated network

All network access is controlled via `egress-proxy`, using squid. All network traffic from the claude container is forced via the egress container, which has a whitelist (`allowed-domains.txt`) of domains claude can access. If claude is somehow compromised, this means it won't be able to reach anything on your local network. It also allows you to prevent claude from visiting sites you do not wish it to.

## Claude Configuration

`claude-base.md` will be concatenated onto any `claude.md` file you have in a specific folder to give base level instructions. Currently, it explains the restrictions in the environment so claude doesn't waste time trying to figure this out if it runs into problems due to the restrictions it is under. You can also give it instructions about how you like it to work/operate so you don't have to repeat yourself.

`claude-managed-settings.json` is a tool level override where you can explicitly force claude to not run certain commands. Unlike `claude.md` files, it is not a suggestion to claude but rather an override in the harness that claude is running in. Currently, it prevents claude from editing git hooks and config, which is one of the vulnerable attack vectors still available.

## Git

Claude will not have access to your ssh keys, and as such will not be able to push to remote refs. You can do this yourself from outside the container, because the workspace folder is mounted from the host.

## Getting started

Create the `workspace` folder. From the host, clone any repositories you want claude to have access to into this folder, then run docker compose up. Exec into the claude container using `docker compose exec claude bash`, or claude directly `docker compose exec -w /workspace/myrepo claude claude`. From there, use claude code normally.