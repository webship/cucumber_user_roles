/**
 * @file
 * Cucumber User Roles steps: shared Webship login and user provisioning.
 */

const { Given, When } = require('@cucumber/cucumber');

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
