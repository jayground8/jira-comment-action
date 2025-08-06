# Jira Commenter GitHub Action

This action adds a comment to a Jira issue with information about a recent GitHub commit.

## Usage

```yaml
- name: Jira Comment
  uses: your-username/jira-comment-action@v1
  with:
    jira_user_email: ${{ secrets.JIRA_USER_EMAIL }}
    jira_api_key: ${{ secrets.JIRA_API_KEY }}
    jira_instance: your-jira-instance.atlassian.net
    issue_key_prefix: 'YOURPROJ' # Optional: e.g., 'PROJ' to extract PROJ-123 from commit message
```

This action uses basic authentication with `jira_user_email` and `jira_api_key`. It will attempt to extract a Jira issue key from the commit message if `issue_key_prefix` is provided. If a match is found (e.g., `YOURPROJ-123`), that issue key will be used. If no `issue_key_prefix` is provided, or if no matching issue key is found in the commit message, the Jira API call will be skipped. The comment body is formatted using Atlassian Document Format.

## License

[MIT](LICENSE)
