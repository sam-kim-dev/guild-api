# Build a Simple Messenger API

This simple messenger API was built as a technical assessment at Guild Education.
## Requirements

1. A short text message can be sent from one user (the sender) to another
(the recipient).
2. Recent messages can be requested for a recipient from a specific sender - with a limit of 100 messages or all messages in last 30 days.
3. Recent messages can be requested from all senders - with a limit of 100
messages or all messages in last 30 days.
4. Document your api like you would be presenting to a web team for use.
5. Show us how you would test your api.
6. Ensure we can start / invoke your api.

## Running Locally

- Ruby Version: 2.7.3
- Rails Version: 6.1.4.1

```
git clone https://github.com/sam-kim-dev/guild-api.git
cd guild-api
bin/rails db:setup
bin/rails s
```

## Running Specs

```
rspec
```

# Messages API Docs
## Sending a Message

In a normal, authenticating API, I would have the "sender" (or current user) be set using token or header auth. Here, I went around that by explicitly setting the current_user to be the DB's first user. If seeded properly, that would be the user "Homer Simpson". In our create message POST requests, we do not need to set the `sender_id` because that is the current user, Homer.

After booting up the server locally, you can run this curl command where the body is whatever you'd like and the recipient ID is 1-5. (1 if you want to send a message to yourself?)

```
POST /api/v1/messages
```
Data
```
{
  "data": {
    "body": "Insert Body Here",
    "recipient_id": 5
  }
}
```

Response
```json
Status: 201 Created

{
  "id": 5,
  "body": "Insert Body Here",
  "sender_id": 1,
  "recipient_id": 5,
  "created_at": "2021-11-09T04:23:01.597Z",
  "updated_at": "2021-11-09T04:23:01.597Z"
}
```

Curl Example
```curl
curl --location --request POST 'localhost:3000/api/v1/messages' \
--header 'Content-Type: application/json' \
--data-raw '{
    "data": {
        "body": "Insert Body Here",
        "recipient_id": 5
    }
}
'
```
---
## Get a List of All Messages

Request up to 100 messages, no older than 30 days, for the user. Some things on my wish list for this route:

- Kaminari (or other pagination) gem
- ETag support for caching

```
GET /api/v1/messages 
```

Response
```json
Status: 200 OK

[
  {
    "id": 1,
    "body": "d'oh",
    "sender_id": 1,
    "recipient_id": 5,
    "created_at": "2021-11-09T03:55:53.024Z",
    "updated_at": "2021-11-09T03:55:53.024Z"
  },
  {
    "id": 1,
    "body": "Howdilly Doodilly",
    "sender_id": 1,
    "recipient_id": 4,
    "created_at": "2021-11-09T03:55:53.024Z",
    "updated_at": "2021-11-09T03:55:53.024Z"
  }
]
```

Curl Example
```curl
curl --request GET 'localhost:3000/api/v1/messages'
```
---
## Get a List of All Messages from a Specific User

Request up to 100 messages, no older than 30 days, for the user with a specific recipient. Also similar wishlist for pagination and caching. The required `:user_id` is the DB ID of the other person who the current user is conversing with.


```
GET /api/v1/messages/:user_id
```

Response
```json
Status: 200 OK

[
  {
    "id": 1,
    "body": "d'oh",
    "sender_id": 1,
    "recipient_id": 5,
    "created_at": "2021-11-09T03:55:53.024Z",
    "updated_at": "2021-11-09T03:55:53.024Z"
  },
  {
    "id": 1,
    "body": "Howdilly Doodilly",
    "sender_id": 5,
    "recipient_id": 1,
    "created_at": "2021-11-09T03:55:53.024Z",
    "updated_at": "2021-11-09T03:55:53.024Z"
  }
]
```

Curl Example
```curl
curl --request GET 'localhost:3000/api/v1/messages/5'
```