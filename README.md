# Cucumber User Roles

Provides a list of user roles, empowering administrators to selectively
assign roles to staff members involved in system operations. Each role
is associated with specific tasks, a dedicated dashboard, and distinct
permissions within the product testing workflow.


## Table of contents

- Features
- Requirements
- Installation
- Usage


## Features

- A "Cucumber User Roles" settings form at
  `/admin/config/development/cucumber-user-roles/settings`, listing every
  available role with its description. Ticking a role and pressing
  *Install User Roles* installs the matching sub-module. A role that is
  already installed stays ticked and disabled.
- The role catalogue lives in `src/Assets/user_roles/user_roles.yml`, so
  titles and descriptions are edited in one place.
- An `administer cucumber user roles settings` permission that guards the
  settings form.
- Six optional sub-modules, one per role. Each ships a `user.role.*`
  config entity with its permissions, a `dashboards.dashboard.*` config
  entity, and a default recipe that flips the role on in
  `cucumber_user_roles.settings`, points `user_redirect` at the role's
  dashboard, and grants the admin role access to that dashboard:

  | Sub-module | Role | Responsibility |
  | --- | --- | --- |
  | `cucumber_user_role_tester` | Tester | Carry out testing to the defined standards and procedures, analyse the results, and report to the development team. |
  | `cucumber_user_role_developer` | Developer | Write and perform productive code, and keep existing rules up to date. |
  | `cucumber_user_role_analyst` | Analyst | Analyse defects and bugs to identify their cause, and keep documentation up to date. |
  | `cucumber_user_role_coordinator` | Coordinator | Day-to-day coordination of test activities, work distribution, plans, and progress. |
  | `cucumber_user_role_designer` | Designer | Turn research findings into design directions and evaluate new system concepts. |
  | `cucumber_user_role_product_owner` | Product Owner | Manage and prioritise the product backlog, and oversee all stages of product creation. |

- Every role gets `access content`, `access features page`,
  `can view <role>_dashboard dashboard` and the use of the Gherkin text
  format. What a role may do with a feature follows its work:

  | Role | Features | Steps of the automated testing workflow |
  | --- | --- | --- |
  | Tester | Creates, changes any | To Do, In Progress, Implemented, back to Draft |
  | Developer | Changes any | To Do, In Progress, Implemented |
  | Analyst | Creates, changes its own | To Do, back to Draft |
  | Designer | Creates, changes its own | To Do, back to Draft |
  | Coordinator | Creates, changes any | Every step, Publish included |
  | Product Owner | Creates, changes any | Every step, Publish included |

  The Coordinator also keeps the feature directories and sees the team.
  No role gets a permission that administers the site. The permissions
  are listed in the default recipe of each sub-module.


## Requirements

This module requires
[Cucumber Core](https://www.drupal.org/project/cucumber_core), which in
turn brings in the Webship configuration stack (`webpatches`,
`webconfig`, `webdev`, `webadmin`, `webassets`), the Dashboards module
behind the per-role dashboards, and User Redirect for the post-login
redirects.


## Installation

Install as you would normally install a contributed Drupal module:

```
composer require drupal/cucumber_user_roles
drush en cucumber_user_roles
```


## Usage

Go to `/admin/config/development/cucumber-user-roles/settings`, tick the
roles the team needs, and press *Install User Roles*. Each ticked role
installs its sub-module, which creates the role with its permissions and
its dashboard.

Assign the new roles to people at `/admin/people`. A user with one of
these roles lands on their own dashboard after logging in, for example
`/dashboard/tester_dashboard`.

Sub-modules can also be installed directly when a site is built from
code:

```
drush en cucumber_user_role_tester cucumber_user_role_developer -y
```
