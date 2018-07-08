# Rails surjection

Experiments of surjective data sync on Rails.

## Overview
There are two Rails projects.

"Project ALPHA" has only **User** table. It's record has one **email** data.

"Project BETA" has **User** and **Email** table. One of **User** record has **many Emails**.

### Table Schemas

Alpha column|Beta column
--|--
User.id|User.id
User.name|User.name
-|Email.id
User.email|User.emails.representative.address

## Usage

### Start server

```
$ cd alpha && bin/rails server --port 3001
$ cd beta  && bin/rails server --port 3002
```

Hit http://localhost:3001/users and http://localhost:3002/users

### One-time Cold sync from ALPHA to BETA

```
$ embulk run embulk/cold/users.yml
$ embulk run embulk/cold/emails.yml
```

### Surjective Hot sync from BETA to ALPHA

Checking difference between two tables.
```
$ bin/rails mysql_view:check[users,beta_users]
There is no difference between users and beta_users.
```

Swaping two tables.
```
$ cd alpha && bin/rails mysql_view:swap[users,beta_users]
```
When swaping table and view, ALPHA application start to use view which created from beta table.

----
## DEPRECATED

```
$ cd beta && bin/rake jobs:work
```

### Cold sync from ALPHA to BETA

```
$ cd beta && bin/rails db:seed; cd -
```

### Surjective hot sync from BETA to ALPHA
If you sync User data from BETA to ALPHA, you need to choice *representative* record of email from BETA Email records what User record has.

As you access BETA project users page and hit "Edit" or "New User" action, automaticaly change ALPHA record which corresponding to BETA record you change

## License

MIT.
