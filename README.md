# Rails Engine Lite

Rails Engine Lite is an API that provides several e-commerce themed endpoints for clients to consume. The production database is pre-seeded with example data for 100 merchants and 2483 items. There's other data there too, but this project focuses only on those two. Please note that this project was completed as a learning exercise and is not intended to be used for real-world applications.

My learning goals for this project included getting more familiar with API-only Rails applications, including building the API functionality itself as well as testing the expected behavior rigorously. I also referenced [JSON:API](https://jsonapi.org/format/#document-jsonapi-object) formatting guidelines to configure the JSON objects that are returned to the client.

## Setup

If you'd like to take Rails Engine Lite for a test drive, setup is easy! Simply clone this repository down to your local machine, and run

```bundle install```

from the command line. Then, create and seed your database with

```bundle exec rake:db{drop,create,migrate,seed}```

and you should be ready to go!

## Usage & Testing

The test suite uses [RSpec](https://rspec.info/) to test expected behavior, and the test suite can be found in the `spec` folder. You can run `bundle exec rspec` from your CLI to run those tests.

Alternatively, you can spin up a rails server using `rails s` and play with the API in real time. Once your server is running, you can visit `http://localhost:3000` in your web browser or use a tool like [Postman](https://www.postman.com/) if you're already familiar with it and proceed to the next section.

## Avalable Endpoints

All endpoints are namespaced under `api/v1`, meaning you'll need to add that to your url before hitting any of the paths below. To get all merchants, for example, your full path would be `/api/v1/merchants`. The available endpoints in v1 are as follows:

**Merchants:**
- all merchants: `GET '/merchants'`
- one merchant: `GET '/merchants/:id`
- get all items for a given merchant ID: `GET '/merchants/:id/items

**Items:**
- all items: `GET '/items'`
- one item: `GET '/items/:id'`
- create an item: `POST '/items'`
- edit an item: `PATCH '/items/:id'`
- delete an item: `DELETE '/items/:id'`
- get the merchant data for a given item ID: `GET '/items/:id/merchant'`

**Search:**
- find a single merchant which matches a search term: `GET /api/vi/merchants/find`
- find all items which match a search term: `GET /api/vi/items/find_all`

### About searches:
- Merchant searches accept only one query parameter, `name`.
- Item searches acccept query parameters of `name`, `min_price`, and `max_price`. Only name **OR** price may be used to filter a single search; minimum price and maximum price can be included in the same search to define a range.
- `/find` endpoints return a single object if at least one object can be found. The results are sorted alphabetically and if there are multiple matches, only the first is returned. **The resulting JSON will always be an object, even if no matches are found.**
- `/find_all` endpoints return an array of objects that match the search query. **The resulting JSON will always be an array, even if no results are found.**

**Valid examples:**
- `GET /api/v1/merchants/find?name=Mart`
- `GET /api/v1/items/find?name=ring`
- `GET /api/v1/items/find?min_price=50`
- `GET /api/v1/items/find?max_price=150`
- `GET /api/v1/items/find?max_price=150&min_price=50`
- `GET /api/v1/items/find_all?name=ring`

***

If you have any questions, feel free to ask!
