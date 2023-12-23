<?php

namespace Drupal\cucumber_user_roles\Form;

use Symfony\Component\Yaml\Yaml;
use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

class UserRolesSettings extends ConfigFormBase {

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

  public function buildForm(array $form, FormStateInterface $form_state) {

    $config = $this->config('cucumber_user_roles.settings');

    // Cucumber User Roles.
    $user_roles_file = DRUPAL_ROOT . '/modules/contrib/cucumber_user_roles/config/user_roles/user_roles.yml';

    if (file_exists($user_roles_file)) {
      $user_roles_content = file_get_contents($user_roles_file);
      $user_roles = (array) Yaml::parse($user_roles_content);

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

    // Cucumber User Roles.
    $user_roles_file = DRUPAL_ROOT . '/modules/contrib/cucumber_user_roles/config/user_roles/user_roles.yml';

    $user_roles_content = file_get_contents($user_roles_file);
    $user_roles = (array) Yaml::parse($user_roles_content);

    $user_roles_options = $user_roles['user_roles']['options'];

    foreach ($user_roles_options as $user_roles_key => $user_roles_info) {

      if ($user_roles_key != "admin" && $form_state->getValue($user_roles_key) == 1 && (bool) $config->get($user_roles_key) == FALSE) {

        $installer = \Drupal::service('module_installer');
        $installer->install([$user_roles_info['source_config']]);
      }
    }

    parent::submitForm($form, $form_state);
  }

}
