# Step definitions

`cucumber_user_roles.steps.js` adds what webship-js does not ship:

- `Given I am a logged in user with the "<X>" user` logs in as a user from
  `cucumber.js` `worldParameters.users`.
- `Given I add testing users` provisions every non-admin user in that
  registry through `/admin/people/create`, assigning their roles.

Both are shared verbatim with the other Cucumber and Webship modules.
