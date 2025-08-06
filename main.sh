#!/bin/bash

set -x # Enable shell debugging

# Construct the Jira API URL
API_URL="https://$JIRA_INSTANCE/rest/api/3/issue/$ISSUE_KEY/comment"

# Construct the comment string
COMMENT="$COMMITTER_USERNAME just pushed a commit to $REPOSITORY_NAME: [$COMMIT_MESSAGE]($COMMIT_URL)"

# Construct the JSON payload in Atlassian Document Format
JSON_PAYLOAD=$(cat <<EOF
{
  "body": {
    "content": [
      {
        "content": [
          {
            "text": "$COMMENT",
            "type": "text"
          }
        ],
        "type": "paragraph"
      }
    ],
    "type": "doc",
    "version": 1
  }
}
EOF
)

echo "Jira API URL: $API_URL"
echo "JSON Payload: $JSON_PAYLOAD"

# Make the API call to Jira
curl -X POST   --user "$JIRA_USER_EMAIL:$JIRA_API_KEY"   --header 'Accept: application/json'   --header 'Content-Type: application/json'   --data "$JSON_PAYLOAD"   "$API_URL"

set +x # Disable shell debugging


