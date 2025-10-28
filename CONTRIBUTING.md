# Contributing to Real-Time Stocks Market Data Pipeline

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, Python version, etc.)

### Suggesting Enhancements

We welcome suggestions! Please create an issue describing:
- The enhancement you'd like to see
- Why it would be useful
- Any implementation ideas

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

1. Clone your fork
2. Install dependencies: `pip install -r requirements.txt`
3. Set up pre-commit hooks (if available)
4. Make your changes
5. Test locally with Docker Compose

## Code Style

- Follow PEP 8 for Python code
- Use meaningful variable and function names
- Add comments for complex logic
- Include docstrings for functions and classes

## Testing

- Test all changes locally before submitting PR
- Ensure Docker services start correctly
- Verify data flows through the pipeline
- Check Airflow DAGs run successfully

## Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests when relevant

## Questions?

Feel free to open an issue for any questions about contributing!
