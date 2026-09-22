# Cucumber User Roles tests

[webship-js](https://www.npmjs.com/package/webship-js) (Playwright +
Cucumber-js) suite, run against plain Drupal core.

```bash
ddev drush site:install standard --account-name=webmaster --account-pass=dD.123123ddd -y
ddev drush en cucumber_user_roles -y
ddev drush en cucumber_user_role_tester cucumber_user_role_developer \
  cucumber_user_role_analyst cucumber_user_role_coordinator \
  cucumber_user_role_designer cucumber_user_role_product_owner -y
yarn install
./node_modules/.bin/playwright install --with-deps chromium
LAUNCH_URL="https://<project>.ddev.site" yarn test
```

CI: the `webship-js-test` job in `.gitlab-ci.yml`.
