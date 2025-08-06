#!/bin/bash

# Construct the Jira API URL
API_URL="https://$JIRA_INSTANCE/rest/api/3/issue/$ISSUE_KEY/comment"

# Construct the JSON payload in Atlassian Document Format
JSON_PAYLOAD=$(cat <<EOF
{
  "body": {
    "content": [
      {
        "content": [
          {
            "text": "$COMMITTER_USERNAME just pushed a ",
            "type": "text"
          },
          {
            "text": "commit",
            "type": "link",
            "marks": [
              {
                "type": "link",
                "attrs": {
                  "href": "$COMMIT_URL"
                }
              }
            ]
          },
          {
            "text": " to $REPOSITORY_NAME\n$COMMIT_MESSAGE",
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
RESPONSE_BODY_FILE=$(mktemp)
HTTP_STATUS=$(curl -s -o "$RESPONSE_BODY_FILE" -w "%{http_code}" -X POST --user "$JIRA_USER_EMAIL:$JIRA_API_KEY" --header 'Accept: application/json' --header 'Content-Type: application/json' --data "$JSON_PAYLOAD" "$API_URL")
RESPONSE_BODY=$(cat "$RESPONSE_BODY_FILE")
rm "$RESPONSE_BODY_FILE"

if [ -z "$HTTP_STATUS" ]; then
  echo "Error: HTTP_STATUS is empty. Curl command might have failed."
  exit 1
fi

echo "Jira API Response: $RESPONSE_BODY"

if [ "$HTTP_STATUS" -ne "201" ]; then
  echo "Error: Jira API request failed with status code $HTTP_STATUS."
  exit 1
fi