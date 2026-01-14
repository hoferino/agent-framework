# Security Rules

## Data Handling
- Never expose sensitive data (API keys, passwords, tokens) in code or logs
- Use environment variables for configuration and secrets
- Validate all user inputs before processing

## Dependencies
- Keep dependencies up to date
- Audit dependencies for known vulnerabilities
- Only install necessary packages

## API Security
- Use HTTPS for all network requests
- Implement proper authentication and authorization
- Rate-limit API calls to prevent abuse

## Code Safety
- Avoid `eval()` and similar dynamic code execution
- Sanitize data before rendering in the DOM
- Use parameterized queries to prevent SQL injection
