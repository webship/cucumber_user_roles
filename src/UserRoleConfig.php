<?php

declare(strict_types=1);

namespace Drupal\cucumber_user_roles;

use Drupal\Core\Config\Entity\ConfigEntityInterface;

/**
 * Keeps the configuration of a Cucumber user role with its module.
 *
 * A role module provides a role and its dashboard. Both are removed when the
 * module is uninstalled, so that the module can be installed again: Drupal
 * refuses to install a module whose configuration is already on the site.
 */
final class UserRoleConfig {

  /**
   * Makes the role and its dashboard depend on the module of the role.
   *
   * The configuration the modules ship says so. A site that installed a role
   * module before gets the same from an update function.
   *
   * @param string $role_id
   *   The machine name of the user role, for example "tester".
   *
   * @return string[]
   *   The names of the configuration that was changed by this call.
   */
  public static function enforceModule(string $role_id): array {
    $module = 'cucumber_user_role_' . $role_id;
    $entities = [
      'user_role' => $role_id,
      'webdashboard' => $role_id . '_dashboard',
    ];

    $changed = [];
    foreach ($entities as $entity_type_id => $id) {
      $entity = \Drupal::entityTypeManager()->getStorage($entity_type_id)->load($id);
      if (!$entity instanceof ConfigEntityInterface) {
        continue;
      }
      $dependencies = $entity->get('dependencies') ?: [];
      if (in_array($module, $dependencies['enforced']['module'] ?? [], TRUE)) {
        continue;
      }
      $dependencies['enforced']['module'][] = $module;
      $entity->set('dependencies', $dependencies)->save();
      $changed[] = $entity->getConfigDependencyName();
    }

    return $changed;
  }

  /**
   * Turns a role off in the Cucumber User Roles settings.
   *
   * @param string $role_id
   *   The machine name of the user role, for example "tester".
   */
  public static function turnOff(string $role_id): void {
    $settings = \Drupal::configFactory()->getEditable('cucumber_user_roles.settings');
    if (!$settings->isNew() && $settings->get($role_id)) {
      $settings->set($role_id, FALSE)->save();
    }
  }

}
