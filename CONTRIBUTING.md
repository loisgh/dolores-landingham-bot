## Contributing

### Code of conduct

We aspire to create a welcoming environment for collaboration on this project.
To that end, we follow the [18F Code of
Conduct](https://github.com/18F/code-of-conduct/blob/master/code-of-conduct.md)
and ask that all contributors do the same.

### Not sure what to work on?

Issues that are ready for contributions are tagged with [help
wanted](https://github.com/18F/dolores-landingham-bot/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22).

Comment on the issue you're working on so we all know who is working on what.

If you're thinking about working on a feature unrelated to an existing issue,
consider creating an issue before you start work to get feedback from the team.
We are always happy to receive pull requests but don't want anyone to feel like
they wasted time if a pull request is submitted but not merged.

### Git Protocol

To contribute to this project, people internal to 18F can create a branch and
submit a pull request. If you are external to 18F, you can fork the repository
and submit a pull request that way.

We are minimizing commits on the `master` branch by rebasing and squashing
commits on branches before merging them into `master`. This will require you to
force push on your branch (but not to `master`...please don't force push
`master`).

For a more detailed walk through on how to do this, you can read thoughtbot's
[Git
Protocol](https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature)
document.

18F-ers can merge their changes into master after getting approval from another
contributor. PRs can be merged manually by merging the branch into `master`
locally and pushing `master` or by using the merge button on GitHub.

### Managing time / Updating holidays
Each message created will send a specified number of **business days** after an employee joins 18F.
What constitutes a business day is managed by the gem `business_time` and is configured [here](config/initializers/business_time.rb) and [here](config/business_time.yml). To add days that dolores will skip, add that date to the `holidays` field in [this yaml config file](config/business_time.yml).

### Vagrant setup

A [Vagrant](http://vagrantup.com) configuration is available that creates a
local server preconfigured with all the dependencies required by this project.

To use vagrant for development:

```
# Provision a new virtual server in VirtualBox (installs postgres, other
# dependencies, and sets up the project's database)
vagrant up

# connect to the server to run foreman, run tests, etc:
vagrant ssh

# Vagrant shares your project's directory with the virtual server in the
# /vagrant directory:
cd /vagrant

# run tests
rake

# Vagrant maps port 5000 of the virtual server to localhost:5000, so it seems
# like you are running the project locally:
foreman start
```

### App setup

Before running bin/setup, ensure that 'foreman' is removed from the Gemfile.  

Prior to running 'bin/setup', it may be necessary to launch the postgres server using 
```postgres -D /usr/local/var/postgres``` You can also use the OS X app.

To get started, run `bin/setup`

If bin/setup fails with the following error message:

```fe_sendauth: no password supplied```
```Couldn't create database for {"adapter"=>"postgresql", "database"=>"postgres", "encoding"=>"utf8", "host"=>"localhost", "min_messages"=>"warning", "pool"=>5, "reaping_frequency"=>10, "timeout"=>5000}```
rake aborted!

check your database.yml file.  You might need to set database credentials (i.e.,username:<uname>, password:<pw>)

After setting up, you can run the application using [foreman]:

    foreman start

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

The application will run locally at http://localhost:5000/.

If you have previously run a project on a different port, a `.foreman` file
may be generated at the root of your directory. If so, make sure that this
file is set to port `5000` or you will be unable to authenticate locally with MyUSA.

If your server isn't defaulting to Port 5000, you may have to add a .foreman file to root directory. In the file, add "port: 5000". 

### Testing
Testing is done using `capybara-poltergeist`, which requires a local install of [phantomjs](https://github.com/jonleighton/poltergeist#installing-phantomjs).
You can run the entire test suite using:

`rake`

### Required Keys

The setup script creates a `.env` file with a dummy environment configuration
variables.  If you are internal to 18F and would like access to these configs,
you can contact Jessie Young. Otherwise, you can create a Slack bot
[here](https://18f.slack.com/services/new/bot).

### Authentication

You will need to be on the developer list to authenticate locally via MyUSA.

If you are internal to 18F, contact Brian Hedberg to be added to the developer
list.  If you are on the list, `dolores-local` will be one of your [Authorized
Applications](https://alpha.my.usa.gov/authorizations) on MyUSA.

If `dolores-local` is on your MyUSA list for Authorized Applications and you
are still unable to authenticate, check with Brian to make sure that the `MYUSA_KEY`
and `MYUSA_SECRET` keys listed in `.env` are up to date.
For more on environmental variables and keys, refer to [Required Keys](#required-keys) above.

If you are not part of 18F and would like to run the application locally, you can
follow these steps:

1. Create a [MyUSA Account](https://alpha.my.usa.gov/) and create an application for
development with the following:

  For Url:

  `http://localhost:5000/`

  For Redirect uri:

  `http://localhost:5000/auth/myusa/callback`

2. Under `Select the API Scopes that your Application will use`: select `Email
   Address`.

3. Generate a set of keys by clicking `New Api Key` next to your application in MyUSA.
   They will be called `Consumer Public Key` and `Consumer Secret Key` on MyUSA but will
   map to `MYUSA_KEY` and `MYUSA_SECRET`, in your local `.env` file.

4. Edit the `AUTH_DOMAIN` value in your local `.env` file such that the `is_permitted` method in
   `/app/controllers/auth_controller` will accept the email address you used in your MyUSA
   application.
  For example, if you use gmail, change the AUTH_DOMAIN to "gmail.com"

```ruby
  # Invocation
  if is_permitted?(auth_email)

  # Method
  def is_permitted?(auth_email)
    /#{ENV['AUTH_DOMAIN']}/.match(auth_email)
  end
```

## Granting Yourself Admin Access

Once you've created an account with MyUSA, open the Rails console and change your admin status to "true". This will allow you to create and schedule messages.

Note: scheduled messages may not send if you're using over the weekend, which is due to the business_time gem referenced above.

## Deployment

Dolores is configured to be deployed with Cloud Foundry as an 18f-er.

Refer to [docs.18f.gov](https://docs.18f.gov/getting-started/setup/) for getting
set up with Cloud Foundry.

The Dolores Landingham bot is deployed within the `18f` Cloud Foundry org. To
see if you have access to the `18f` do the following in the root of your repo:

`cf orgs`

If `18f` does not show up as an available org, you can request access by
posting an issue to the [DevOps repo](https://github.com/18F/DevOps/issues/new)
on GitHub.

Once you have access to the org, you can target the Cloud Foundry organization
and space for this project:

`cf target -o 18f -s dolores`

Once your target is set, you can push the application. We have two Cloud Foundry
instances: `dolores-app` and `dolores-staging`. Test your changes by pushing to
`dolores-staging` before pushing to the `dolores-app` instance.

`cf push <app-instance-name>`

New migrations will be run automatically. See the [manifest](manifest.yml) for
more details on the Cloud Foundry setup.

To see existing environment variables:

`cf env <app-instance-name>`

To set or change the value of an environment variable:

`cf set-env <app-instance-name> <env-name> <env-value>`
