# ZSSN (Zombie Survival Social Network)

ARE WE NEGAN?

System for share resources between non-infected humans

* [Info Resources](#info-resources)
* [List Survivors](#list-survivors)
* [Add Survivors](#add-survivors)
* [Update Survivor Location](#update-survivor-location)
* [Flag Survivor as Infected](#flag-survivor-as-infected)
* [Exchange Resources](#exchange-resources)
* [Percentage of infected survivors](#percentage-of-infected-survivors)
* [Percentage of non-infected survivors](#percentage-of-non-infected-survivors)
* [Average Resources By Survivor](#average-resources-by-survivor)
* [Points lost because of infected survivors](#points-lost-because-of-infected-survivors)
* [Testing with RSpec](#testing-with-rspec)

## Example

[ZSSN API on Heroku](https://zssn-api-kadusim.herokuapp.com)

## Installation

1. Clone the project.

````
https://kadusim@bitbucket.org/kadusim/zssn-api.git
````

2. Bundle the Gems.

````bash
bundle install
````

3. Default resources.

````bash
rails db:create
````

````bash
rails db:migration
````

````bash
rails db:seed
````

4. Start the application

````bash
rails s
````

Application will be runing at [localhost:3000](http://localhost:3000).

## API Documentation

### Info Resources

##### Request

````
GET api/resources`
````

##### Response

````
status: 200 Ok
````

````
Content-Type: "application/json"
````

````json
Body:
[
	{
		"id": 1,
		"item": "water",
		"value": 4
	},
	{
		"id": 2,
		"item": "food",
		"value": 3
	},
	{
		"id": 3,
		"item": "medication",
		"value": 2
	},
	{
		"id": 4,
		"item": "ammunition",
		"value": 1
	}
]
````

### List Survivors

##### Request

````
GET api/survivors`
````

##### Response

````
status: 200 Ok
````

````
Content-Type: "application/json"
````

````json
Body:
[
    {
        "id": 1,
        "name": "Kadu",
        "age": 29,
        "gender": "M",
        "latitude": "12.783827",
        "longitude": "78.821028",
        "infected": false,
        "resources": [
            {
                "id": 2,
                "item": "food",
                "value": 3,
                "created_at": "2018-04-30T14:38:44.776Z",
                "updated_at": "2018-04-30T14:38:44.776Z"
            },
            {
                "id": 1,
                "item": "water",
                "value": 4,
                "created_at": "2018-04-30T14:38:44.753Z",
                "updated_at": "2018-04-30T14:38:44.753Z"
            }
        ]
    },
    {
        "id": 3,
        "name": "Nalu",
        "age": 9,
        "gender": "F",
        "latitude": "22.874897",
        "longitude": "-74.982948",
        "infected": false,
        "resources": [
            {
                "id": 3,
                "item": "medication",
                "value": 2,
                "created_at": "2018-04-30T14:38:44.789Z",
                "updated_at": "2018-04-30T14:38:44.789Z"
            }
        ]
    }
]
````

### Add Survivors

##### Request

````
POST api/survivors`
````

````json
Parameters:
{
    "survivor": {
      "name":      "Celia",
      "age":       "29",
      "gender":    "F",
      "latitude":  "25.874897",
      "longitude": "-77.9829482",
      "infected":  false,
      "inventory_attributes": {
        "inventory_resources_attributes": [
          { "resource_id": 1 },
          { "resource_id": 2 },
          { "resource_id": 3 },
          { "resource_id": 3 },
          { "resource_id": 4 }
        ]
      }
    }
}
````

##### Response

````
status: 201 created
````

````
Content-Type: "application/json"
````

````json
Body:
{
    "id": 5,
    "name": "Celia",
    "age": 23,
    "gender": "M",
    "latitude": "25.874897",
    "longitude": "-77.982948",
    "infected": false,
    "resources": [
        {
            "id": 1,
            "item": "water",
            "value": 4,
            "created_at": "2018-04-30T14:38:44.753Z",
            "updated_at": "2018-04-30T14:38:44.753Z"
        },
        {
            "id": 2,
            "item": "food",
            "value": 3,
            "created_at": "2018-04-30T14:38:44.776Z",
            "updated_at": "2018-04-30T14:38:44.776Z"
        },
        {
            "id": 3,
            "item": "medication",
            "value": 2,
            "created_at": "2018-04-30T14:38:44.789Z",
            "updated_at": "2018-04-30T14:38:44.789Z"
        },
        {
            "id": 3,
            "item": "medication",
            "value": 2,
            "created_at": "2018-04-30T14:38:44.789Z",
            "updated_at": "2018-04-30T14:38:44.789Z"
        },
        {
            "id": 4,
            "item": "ammunition",
            "value": 1,
            "created_at": "2018-04-30T14:38:44.800Z",
            "updated_at": "2018-04-30T14:38:44.800Z"
        }
    ]
}
````

##### Errors
Status | Error                | Message
------ | ---------------------|--------
422    | unprocessable_entity | {field} can't be blank

### Update Survivor Location

##### Request

````
PATCH/PUT api/survivors/:id
````

````json
Parameters:
{
    "survivor": {
      "latitude":  "12.7838273",
      "longitude": "78.8210282"
    }
}
````

##### Response

````
status: 204 no_content
````

````
Content-Type: "application/json"
````

##### Errors
Status | Error      |
------ | -----------|
404    | Not Found  |

### Flag Survivor as Infected

##### Request

````
POST api/infected_report
````

````json
Parameters:
Body:
{
	"survivor_id": 2,
	"reporter_id": 4
}
````

##### Response

````
status: 201 created
````

````
Content-Type: "application/json"
````

````json
Body:
{
  	"message": "Survivor reported successfully"
}
````

##### Errors
Status | Error                | Description
------ | -------------------- | ------------------------------------------
422    | unprocessable_entity | Reporter has already reported the survivor
404    | Not Found            | Couldn't find Survivor
403    | Forbidden            | Survivor or reporter was infected

### Exchange Resources

##### Request

````
POST api/exchanges
````

````json
Parameters:
{
    "exchanges": {
      "survivor_one": {
        "id": 1,
        "resources": [
          {
            "resource_id": 4,
            "quantity": 2
          },
          {
            "resource_id": 3,
            "quantity": 1
          }
        ]
      },
      "survivor_two": {
        "id": 3,
        "resources": [
          {
            "resource_id": 1,
            "quantity": 1
          }
        ]
      }
    }
}
````

##### Response

````
status: 200 ok
````

````
Content-Type: "application/json"
````

````json
Body:
{
  "message": "Successful exchange"
}
````

##### Errors
Status | Error                | Message
------ | ---------------------|--------
404    | Not Found            | Couldn't find Survivor with 'id'={id}
401    | Unauthorized         | Be careful, survivor id:{id} is infected
401    | Unauthorized         | Survivor id:{id} no have enough resources for exchange
401    | Unauthorized         | An exchange must be made with the same amount of points


## Reports

### Percentage of infected survivors

##### Request

````
GET api/reports/percentage_infected_survivors
````

##### Response

````
status: 200 ok
````

````
Content-Type: "application/json"
````

````json
Body:
{
  "percentage": "50.0"
}
````

status: 200 ok if no survivors
````json
Body:
{
  "message": "No survivors found"
}
````

### Percentage of non-infected survivors

##### Request

````
GET api/reports/percentage_non_infected_survivors
````

##### Response

````
status: 200 ok
````

````
Content-Type: "application/json"
````

````json
Body:
{
  "percentage": "50.0"
}
````

status: 200 ok if no survivors
````json
Body:
{
  "message": "No survivors found"
}
````

### Average Resources By Survivor

##### Request

````
GET api/reports/average_resources_by_survivor
````

##### Response

````
status: 200 ok
````

````
Content-Type: "application/json"
````

````json
Body:
{
  "averages": {
	  "water": 10,
	  "food": 5,
	  "medication": 2,
	  "ammunition": 30
  }
}
````

status: 200 ok if no survivors
````json
Body:
{
  "message": "No survivors found"
}
````

### Points lost because of infected survivors

##### Request

````
GET api/reports/points_lost_because_infected
````

##### Response

````
status: 200 ok
````

````
Content-Type: "application/json"
````

````json
Body:
{
  "points_lost": 100
}
````

status: 200 ok if no survivors
````json
Body:
{
  "message": "No survivors found"
}
````

## Testing with RSpec

1. Execute all tests

````
rspec
````

- by [Kadu Simões](https://github.com/kadusim)
