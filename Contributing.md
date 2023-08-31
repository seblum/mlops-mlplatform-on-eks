# Contributing to *ML Platform on EKS*

Your interest in contributing to *ML Platform on EKS* is greatly appreciated! We embrace contributions from the community to enhance and refine our project. To ensure a seamless and collaborative contribution experience, please adhere to the following guidelines.

## Getting Started

Begin by forking the repository on GitHub and then cloning your forked copy to your local machine.

## Making Contributions

When making contributions:

### Branching

Create a new branch for your changes with a descriptive name that mirrors the purpose of your contribution (e.g., `feature/add-new-feature`).

### Commit Messages

Compose clear and concise commit messages:
- Prefer the present tense (e.g., "Add feature" instead of "Added feature").
- Offer context and insights about your changes.

### Testing

Include tests if relevant and ensure that any pre-existing tests pass.

### Pre-commit Hooks

This repository utilizes pre-commit hooks to enhance code quality and minimize errors. These hooks automatically perform checks before commits, ensuring higher reliability. Install pre-commit using `pip install pre-commit` if not already done. Next, navigate to the root directory of the project and set up the hooks via `pre-commit install`. As you make changes to code or files, add modified files using `git add`. Finally, commit changes in the usual way using `git commit -m "Your commit message"`. If any issues arise based on formatting, linting, or other criteria, commits are paused until addressed. This approach guarantees uniform code quality and diminishes the risk of errors.

## Submitting Contributions

To submit your contributions:

1. Push your changes to your forked repository.
2. Forge a pull request (PR) from your branch to the main branch of the original repository.
3. Furnish your PR with an informative title and a comprehensive description elucidating your changes and their significance.

## Code Review

Anticipate feedback from maintainers and fellow contributors. Address any comments and iterate on your work. Maintain a constructive and respectful demeanor throughout the code review process.

## Communication

Stay engaged through our community forum or chat if available. For major changes, it's prudent to discuss them before embarking on substantial contributions.

## License

By participating in this project, you acknowledge that your contributions are subject to the terms of the [Project License](./LICENSE).

Your contributions are immensely valued, and we eagerly anticipate collaborating with you!


## TODOs

### General:
- [ ] Test GitHub actions for automatic deployment.
- [ ] Add secrets to GitHub actions for secure handling of sensitive information.

### Security and User Management:
- [ ] Enhance cluster security to limit public access to sensitive components.

### JupyterHub Improvements:
- [ ] Health check for JupyterHub ALB is currently failing

### ExternalDNS Setup:
- [ ] Limit hosted zone in ExternalDNS for better control over DNS records.

### AWS EKS Cluster:
- [ ] Set EKS cluster to not be publicly accessible to improve security.
