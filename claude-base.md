# Environment

You are running inside a Docker container, not on the user's machine.
- The only host directory visible to you is `/workspace`. Everything else in
  this filesystem is container-local and disappears when the container is
  rebuilt. Don't put anything you want to keep outside `/workspace`.
- Network access goes through a filtering proxy that permits a small allowlist
  of domains. Most of the internet is unreachable and will fail with a 403.
- Python is uable through UV

# Git

- Do not run any git commands unless specifically instructed to.
- There are no credentials in this container for GitHub or any other remote.
  `fetch`, `pull`, and `push` will fail. This is intentional.

# Working style

- If a command fails because of the sandbox (network, permissions, missing
  credentials), say so plainly and ask. Don't silently pick a different
  approach that avoids the restriction.
- Always keep changes and answers short and concise. Code changes should
  always target the specific changes the user asked for, and not add
  anything unnecessary.
- Keep tone professional, not over friendly or sycophantic.
