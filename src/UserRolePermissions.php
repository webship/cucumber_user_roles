<?php

declare(strict_types=1);

namespace Drupal\cucumber_user_roles;

use Drupal\Component\Serialization\Yaml;
use Drupal\user\RoleInterface;

/**
 * Grants a Cucumber user role the permissions its default recipe lists.
 *
 * A recipe is applied when a role module is installed. A site that installed
 * the module before its recipe listed a permission gets that permission from
 * an update function, which reads the same list: what a role may do is
 * written down once, in the recipe of the module that owns the role.
 */
final class UserRolePermissions {

  /**
   * Grants a role the permissions the recipe lists for it.
   *
   * A permission the site does not know is skipped: a site may have removed
   * the module or the configuration that permission stands for.
   *
   * @param string $role_id
   *   The machine name of the user role, for example "tester".
   * @param string $recipe_directory
   *   The directory of the recipe that lists the permissions of the role.
   *
   * @return string[]
   *   The permissions that were granted by this call.
   */
  public static function grantFromRecipe(string $role_id, string $recipe_directory): array {
    $file = $recipe_directory . '/recipe.yml';
    if (!is_readable($file)) {
      return [];
    }
    $recipe = Yaml::decode((string) file_get_contents($file));
    $wanted = $recipe['config']['actions']['user.role.' . $role_id]['grantPermissions'] ?? [];

    $role = \Drupal::entityTypeManager()->getStorage('user_role')->load($role_id);
    if (!$role instanceof RoleInterface || $role->isAdmin() || !$wanted) {
      return [];
    }

    $known = array_keys(\Drupal::service('user.permissions')->getPermissions());
    $granted = [];
    foreach (array_intersect($wanted, $known) as $permission) {
      if (!$role->hasPermission($permission)) {
        $role->grantPermission($permission);
        $granted[] = $permission;
      }
    }
    if ($granted) {
      $role->save();
    }

    return $granted;
  }

}
