<?php

declare(strict_types=1);

namespace Drupal\cucumber_user_roles;

/**
 * Sets the User Redirect login / logout paths for a Cucumber user role.
 *
 * The "user_redirect.settings" config object is owned by the contributed
 * User Redirect module, which ships no config schema for it. Config actions
 * (and therefore recipes) require every config object they touch to be
 * schema-backed: ConfigActionManager::applyAction() asserts that the typed
 * config it builds after the action is a
 * \Drupal\Core\Config\Schema\Mapping, which is never true for a config
 * object with no schema. On a site running with assertions enabled -- as
 * DrupalCI and any properly configured development site do -- a
 * "simple_config_update" action against "user_redirect.settings" therefore
 * aborts the install part way through.
 *
 * Until User Redirect ships its own schema, the Cucumber user role modules
 * write these paths with the plain config API instead, which has never
 * required a schema. As a bonus this also works when the config object does
 * not exist yet, whereas "simple_config_update" fails outright on a missing
 * config object.
 *
 * @see https://www.drupal.org/project/user_redirect
 */
final class UserRoleRedirect {

  /**
   * The name of the User Redirect settings config object.
   */
  public const CONFIG_NAME = 'user_redirect.settings';

  /**
   * Sets the login and logout redirect paths for a single user role.
   *
   * @param string $role_id
   *   The machine name of the user role, for example "tester".
   * @param string $login_url
   *   The path to redirect the role to after login.
   * @param string $logout_url
   *   The path to redirect the role to after logout.
   */
  public static function set(string $role_id, string $login_url, string $logout_url): void {
    \Drupal::configFactory()
      ->getEditable(self::CONFIG_NAME)
      ->set('login.' . $role_id . '.redirect_url', $login_url)
      ->set('logout.' . $role_id . '.redirect_url', $logout_url)
      ->save();
  }

  /**
   * Removes the login and logout redirect paths for a single user role.
   *
   * @param string $role_id
   *   The machine name of the user role, for example "tester".
   */
  public static function remove(string $role_id): void {
    \Drupal::configFactory()
      ->getEditable(self::CONFIG_NAME)
      ->clear('login.' . $role_id)
      ->clear('logout.' . $role_id)
      ->save();
  }

}
