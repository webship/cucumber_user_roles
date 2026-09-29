/**
 * @file
 * Cucumber User Roles steps: shared Webship login and user provisioning.
 */

const { Given, When } = require('@cucumber/cucumber');

/**
 * Log in as a named test user defined in cucumber.js worldParameters.users.
 *
 * The Webmaster row is the site-install super-admin. Every other row is
 * provisioned by `Given I add testing users` (see below). The same
 * phrasing is used by the other Cucumber and Webship modules so suites
 * can move between projects without re-learning step names.
 *
 * Example #1: Given I am a logged in user with the "Webmaster" user
 * Example #2: Given I am a logged in user with the "Tester" user
 * Example #3: Given I am a logged in user with the "Authenticated user" user
 * Example #4: Given I am a logged in user with the username "Tester" user
 * Example #5: Given I am a logged in user with "Webmaster"
 */
Given(
  /^I am a logged in user with( the)*( username)* "([^"]*)?"( user)?$/,
  async function (theCase, usernameCase, key, userCase) {
    const users = this.parameters.users || {};
    if (!(key in users)) {
      throw new Error(
        `No user named "${key}" in cucumber.js worldParameters.users`,
      );
    }
    const { username, password } = users[key];
    if (!username || !password) {
      throw new Error(
        `User "${key}" is missing username or password in worldParameters.users`,
      );
    }
    await this.page.goto(`${this.parameters.launchUrl}/user/login`);
    // View Password, installed through Web Admin, adds a "Show password"
    // button labelled after the field, so target the login inputs by id.
    await this.page.locator('#edit-name').fill(username);
    await this.page.locator('#edit-pass').fill(password);
    await this.page.locator('input[value="Log in"]').click();
    await this.page.waitForLoadState('networkidle');
  },
);

/**
 * Provision every non-admin user from cucumber.js worldParameters.users via
 * Drupal's /admin/people/create form. Entries flagged isAdmin: true are
 * skipped (the site-install Webmaster already exists). Idempotent: a
 * second run reports "name is already taken" and the step swallows it.
 *
 * Must be invoked while logged in as the Webmaster (or any user with the
 * "administer users" permission).
 *
 * Example #1: Given I add testing users
 * Example #2: And I add testing users
 * Example #3: When I add testing users
 * Example #4: Given I add the testing users
 * Example #5: And we add testing users
 */
Given(/^(?:I |we )?add( the)? testing users$/, async function (theCase) {
  const users = this.parameters.users || {};
  for (const [key, info] of Object.entries(users)) {
    if (info.isAdmin) continue;
    await this.page.goto(`${this.parameters.launchUrl}/admin/people/create`);
    await this.page.locator('#edit-name').fill(info.username);
    await this.page
      .locator('#edit-mail')
      .fill(info.email || `${info.username}@example.test`);
    await this.page.locator('#edit-pass-pass1').fill(info.password);
    await this.page.locator('#edit-pass-pass2').fill(info.password);
    for (const role of info.roles || []) {
      const cb = this.page.locator(`input[name="roles[${role}]"]`);
      if ((await cb.count()) > 0) await cb.check();
    }
    await this.page.locator('#edit-submit').click();
    await this.page.waitForLoadState('networkidle');
  }
});

/**
 * Set the content of the Ace editor that replaced a textarea, then wait for
 * ace_editor's debounced sync back to the hidden textarea.
 *
 * Example #1: When I fill in the Ace editor with:
 * Example #2: And I fill in the Ace editor with:
 * Example #3: When we fill in the Ace editor with:
 * Example #4: And we fill in the Ace editor with:
 * Example #5: When fill in the Ace editor with:
 */
When(/^(?:I |we )?fill in the Ace editor with:$/, async function (text) {
  await this.page.waitForFunction(
    () => window.ace && document.querySelector('.ace_editor'),
    null,
    { timeout: 15000 },
  );
  await this.page.evaluate((value) => {
    window.ace
      .edit(document.querySelector('.ace_editor'))
      .session.setValue(value);
  }, text);
  await this.page.waitForTimeout(700);
});
