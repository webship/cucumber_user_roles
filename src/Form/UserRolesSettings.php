<?php

namespace Drupal\cucumber_user_roles\Form;

use Drupal\Component\Serialization\Yaml;
use Drupal\Core\Extension\ModuleExtensionList;
use Drupal\Core\Extension\ModuleInstallerInterface;
use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Installs the user roles of Cucumber.
 */
class UserRolesSettings extends ConfigFormBase {

  /**
   * The list of modules.
   */
  protected ModuleExtensionList $moduleList;

  /**
   * The module installer.
   */
  protected ModuleInstallerInterface $moduleInstaller;

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    $instance = parent::create($container);
    $instance->moduleList = $container->get('extension.list.module');
    $instance->moduleInstaller = $container->get('module_installer');
    return $instance;
  }

  /**
   * Reads the user roles this module offers.
   *
   * @return array
   *   The content of user_roles.yml, or an empty array without the file.
   */
  protected function userRoles(): array {
    $file = $this->moduleList->getPath('cucumber_user_roles') . '/src/Assets/user_roles/user_roles.yml';
    return file_exists($file) ? (array) Yaml::decode((string) file_get_contents($file)) : [];
  }

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'cucumber_user_roles_settings';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return ['cucumber_user_roles.settings'];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {

    $config = $this->config('cucumber_user_roles.settings');
    $user_roles = $this->userRoles();

    if ($user_roles) {

      $form['#title'] = $this->t($user_roles['user_roles']['display_name']);
      $form['description'] = [
        '#weight' => -1,
        '#prefix' => '<p>',
        '#markup' => $this->t($user_roles['user_roles']['description']),
        '#suffix' => '</p>',
      ];

      $form['user_roles'] = [
        "#name" => "user_roles",
        '#type' => 'fieldset',
      ];

      $user_roles_options = $user_roles['user_roles']['options'];

      foreach ($user_roles_options as $user_roles_key => $user_roles_info) {

        $form['user_roles'][$user_roles_key] = [
          '#type' => 'checkbox',
          '#title' => $user_roles_info['title'],
          '#description' => $user_roles_info['description'],
          '#default_value' => $config->get($user_roles_key),
          '#disabled' => $config->get($user_roles_key),
        ];
      }
    }

    $form['actions'] = [
      'continue' => [
        '#type' => 'submit',
        '#value' => $this->t('Install User Roles'),
        '#button_type' => 'primary',
      ],
      '#type' => 'actions',
      '#weight' => 5,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {

    $config = $this->config('cucumber_user_roles.settings');

    $user_roles = $this->userRoles();
    $user_roles_options = $user_roles['user_roles']['options'] ?? [];

    foreach ($user_roles_options as $user_roles_key => $user_roles_info) {

      if ($user_roles_key != "admin" && $form_state->getValue($user_roles_key) == 1 && (bool) $config->get($user_roles_key) == FALSE) {

        $this->moduleInstaller->install([$user_roles_info['source_config']]);
      }
    }

    parent::submitForm($form, $form_state);
  }

}
