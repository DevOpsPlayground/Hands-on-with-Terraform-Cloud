# __DevOps Playground:__ Hands-on with Terraform Cloud
---

![DevOps Playground logo][dpg]

![Terraform Cloud logo][tfc]

---

## Creating and connecting prerequisite accounts

### 1) Have a GitHub account

If you don't have a GitHub account already, head over to https://github.com/ and create one for free!

### 2) Have a Terraform Cloud account

If you don't have a Terraform Cloud account already, head over to https://app.terraform.io/ and create one for free!

You will need to create an **Organization** within Terraform Cloud, but this can be a personal one (e.g. same name as your username, if available).

### 3) Connect Terraform Cloud to your GitHub account

Usually right after you create your Organization in Terraform Cloud, Terraform will redirect you to the page to **Create a new Workspace**.  
If this is not the case, select your Organization from the top-left drop-down menu, then click the button **+ New workspace** in the top-right corner.

Under **Connect to a version control provider**, select **GitHub ˅**, then click on **GitHub.com**.

⚠️ You may need to allow pop-ups / disable pop-up blockers for this step, and manually allow blocked pop-ups to display.

Follow instructions in the pop-up to install Terraform Cloud in your GitHub account, and grant it access to your GitHub account.  
(If you are not happy to grant Terraform Cloud access to all of your GitHub repos, you can come back to this step after you have forked the sample Terraform project repo, and grant Terraform Cloud access to that repo only.)

---

## Setting up and Configuring our Pipeline

### 1) **GitHub:** Clone provided repository

In this section, you are going to create new repository which contains the (pre-written) Terraform code to provision our web app.

The easiest way to achieve this is to fork the following GitHub repository onto your GitHub account:

1. Navigate to the existing repository, if necessary: https://github.com/DevOpsPlayground/Hands-on-with-Terraform-Cloud.

2. Click on the **Fork** button (top right). (You may need to then select your own GitHub username.)

You now have your own copy of our sample Terraform project in your GitHub account. This currently has only one branch, `master`. We will set up more branches soon.

### 2) **Terraform Cloud:** Create New Workspace (prod)

We are going to start by creating a *production* workspace, which is going to deploy our production infrastructure and webapp.  
This can be thought of as the 'live' environment, or the one your end-customers will see (as opposed to ones used for testing and QA).  
In our case, the production environment corresponds to the 'master' branch.

1. Click on **New Workspace** in your Organization

ℹ️ If you haven't connected Terraform Cloud to your GitHub account yet, you will need to do so now.

2. Select **GitHub** as your version control provider

3. Select the repository you forked (probably `Hands-on-with-Terraform-Cloud`).  
(You may need to refresh this page, if your repo does not show up.)  
(You may need to select your own GitHub username in the drop-down list first.)

4. Name the Workspace `2048-prod`.

5. Click **Create workspace**.

### 3) **Terraform Cloud:** Configure your Workspace (prod)

1. Wait for the Terraform configuration to be loaded from GitHub.  
(This may be instant, or take a few seconds.)

2. Click the purple **Configure variables** button, or the link **Variables** in the navigation bar, top-right.

3. Set the following **Terraform Variables**:

| Type                 | Key                     | Value                                                           | HCL? | Sensitive? | Description  |
|----------------------|-------------------------|-----------------------------------------------------------------|------|------------|--------------|
| Terraform Variable   | `animal`                | _The animal you have been assigned for this DevOps Playground._ | No   | No         | _(optional)_ |
| Terraform Variable   | `env`                   | `prod`                                                          | No   | No         | _(optional)_ |

ℹ️ For each variable above, you need to click **+ Add variable**, enter the name of the variable as the **Key** and its value as the **Value**, then click the purple **Save Variable** button.

4. Set the following **Environment Variables**:

| Type                 | Key                     | Value                                                           | Sensitive? | Description  |
|----------------------|-------------------------|-----------------------------------------------------------------|------------|--------------|
| Environment Variable | `AWS_ACCESS_KEY_ID`     | _Your AWS Access Key ID._                                       | **Yes**      | _(optional)_ |
| Environment Variable | `AWS_SECRET_ACCESS_KEY` | _Your AWS Secret Access Key._                                   | **Yes**      | _(optional)_ |

ℹ️ For each variable above, you need to click **+ Add variable**, enter the name of the variable as the **Key** and its value as the **Value**, then click the purple **Save Variable** button.


5. In the navigation bar for your workspace, top-right, click **Settings ˅** (next to **Runs**, **States**, **Variables**), then **General**.

6. As **Apply Method**, set **Auto apply**.

7. Click the purple **Save setting** button at the bottom of the page.

## 4) **Terraform Cloud:** Deploying your project (prod)

1. In the top-right corner, click **Queue plan**.

2. As your reason for queueing plan, enter `Initial deployment` (this is optional).

3. Click the purple **Queue plan** button.

You can now see Terraform Cloud run a `terraform plan`, where it reads our project configuration from GitHub and the variables we have set, maps out its dependency tree, and installs the necessary providers and modules.  
After this is done, it displays a list of resources it plans on creating, and should end its output with the following summary:
```
Plan: 3 to add, 0 to change, 0 to destroy.
```

After Terraform Cloud is done with the Plan phase, it automatically runs a `terraform apply`, where it takes the plan generated above, and makes all the API calls (to the AWS API) which effect our resources being created.  
Note that, had we not selected 'Auto apply' in step **3) 6.** above, Terraform Cloud would have asked us to manually confirm the Plan before proceeding to the Apply phase.)

At the end of the Apply phase, Terraform prints any Outputs defined in our project. Here we have one output, `url`, the URL under which we can reach our webapp.  
You can copy-paste the URL into a new tab in your browser and see the webapp in action!

(You can expand and collapse the different phases in this view. You may need to expand the Apply phase by clicking on **Apply finished**.)

ℹ️ You may also need to wait up to a minute for the DNS record to become available after your apply finished.

### 5) **GitHub:** Create a *staging* branch

Go back to GitHub.com and go to the repository you have forked before.

1. In your forked GitHub repo, click the grey **Branch: master** button (left, above the list of files).

2. Enter `staging`.

3. Click **Create branch: staging from 'master'**

You now have a branch called 'staging'. This is commonly used to host code we consider ready to be deployed, but haven't tested to the desired level of confidence yet.

In the next few steps, we will set up a *staging environment*, which we can use to test the code in our staging branch.

### 6) **Terraform Cloud:** Create New Workspace (staging)

A different environment will typically correspond to a new *Workspace* in Terraform Cloud.

1. Click on **New Workspace** in your Organization

2. Select **GitHub** as your version control provider

3. Select the repository you forked (probably `Hands-on-with-Terraform-Cloud`).  
(You may need to select your own GitHub username in the drop-down list first.)

4. Name the Workspace `2048-staging`.

5. Expand the **˅ Advanced options** menu.  
⚠️ This is an extra step, compared to the 'prod' workspace above.

6. Set **VCS branch** to `staging`. This is the branch we created under step **5)** above.  
⚠️ This is an extra step, compared to the 'prod' workspace above.

7. Click **Create workspace**.

## 7) **Terraform Cloud:** Configure your Workspace (staging)

1. Wait for the Terraform configuration to be loaded from GitHub.  
(This may be instant, or take a few seconds.)

2. Click the purple **Configure variables** button, or the link **Variables** in the navigation bar, top-right.

3. Set the following **Terraform Variables**:

| Type                 | Key                     | Value                                                           | HCL? | Sensitive? | Description  |
|----------------------|-------------------------|-----------------------------------------------------------------|------|------------|--------------|
| Terraform Variable   | `animal`                | _The animal you have been assigned for this DevOps Playground._ | No   | No         | _(optional)_ |
| Terraform Variable   | `env`                   | `staging`                                                          | No   | No         | _(optional)_ |

ℹ️ For each variable above, you need to click **+ Add variable**, enter the name of the variable as the **Key** and its value as the **Value**, then click the purple **Save Variable** button.

4. Set the following **Environment Variables**:

| Type                 | Key                     | Value                                                           | Sensitive? | Description  |
|----------------------|-------------------------|-----------------------------------------------------------------|------------|--------------|
| Environment Variable | `AWS_ACCESS_KEY_ID`     | _Your AWS Access Key ID._                                       | **Yes**      | _(optional)_ |
| Environment Variable | `AWS_SECRET_ACCESS_KEY` | _Your AWS Secret Access Key._                                   | **Yes**      | _(optional)_ |

ℹ️ For each variable above, you need to click **+ Add variable**, enter the name of the variable as the **Key** and its value as the **Value**, then click the purple **Save Variable** button.

5. In the navigation bar, top-right, click **Settings ˅**, then **General**.

6. As **Apply Method**, set **Auto apply**.

7. Click the purple **Save setting** button at the bottom of the page.


### 8) **Terraform Cloud:** Deploying your project (staging)

1. In the top-right corner, click **Queue plan**.

2. As your reason for queueing plan, enter `Initial deployment` (this is optional).

3. Click the purple **Queue plan** button.

Same as for production above, Terraform will output the URL under which we can reach our webapp.  
📝 Make a note of this, as we will need it for step **9)** below.

### 9) **GitHub:** Create a *dev* branch

1. In your forked GitHub repo, click the grey **Branch: staging** button (left, above the list of files).

2. Enter `dev`.

3. Click **Create branch: dev from 'staging'**

You now have a branch called 'dev'. This is commonly used to host code that is not yet ready to be deployed, but is using by developers to work on new features or fixes.

Though one might want to depending on the situation, we will not set up a staging environment.

### 10) **GitHub:** Set up a GitHub Action

1. In your forked GitHub repo, click the grey **Branch: dev** button (left, above the list of files).

2. Click **master** to switch to the master branch.

3. Click the grey **Create new file** button, to the right.

4. Type `.github/workflows/prod-PR.yml` where it says 'Name your file…'.  
Note how the text field changes to display the path whenever you enter a slash character.

5. Enter the following as the file content, **replacing `<staging url>` with the URL for your staging environment** (cf. step **8)**):

```
name: prod-PR

on:
  pull_request:
    branches:
      - master

jobs:
  staging-healthcheck:
    runs-on: ubuntu-latest
    steps:
      - name: Healthcheck the staging endpoint
        run: curl <staging url>


```
⚠️ Make sure to remove the angular brackets when you replace `<staging url>` with the actual URL for your staging environment!

6. Click the green **Commit new file** button.  
Leave 'Commit directly to the `master` branch' selected.  
(It is generally not best practice to commit directly to master, but acceptable in an initial setup phase such as this. We could now _protect_ certain branches, such as staging and master, so that users cannot commit/push directly to those branches, but _have to_ create a pull request instead.)

We have now set up a GitHub Action which will be triggered whenever a pull request (PR) into the *master branch* is opened.  
The only job defined, 'staging-healthcheck', will simply check if the staging environment is reachable. If it is not, that means that the production environment likely won't be reachable either once this new code is deployed, and thus GitHub will veto* this code merge.

(**\* Note:** in our case, GitHub will alert us that some checks haven't passed, but will still allow us to merge the pull request. Checks can be configured to be mandatory in GitHub, under **Settings** -> **Branches** -> **Branch protection rules**. However, they need to have been triggered at least once within the last week in order to be configurable, which is why we cannot yet do this at this stage.)

---

## Testing our Deployment Pipeline

### 1) Syntax error

In this section, we will introduce a syntax error into our Terraform project (on the 'dev' branch), and try to merge this into Staging (via a 'Pull Request').

Terraform Cloud should automatically check if this new code could be deployed to the staging environment, and let GitHub know if there is an issue. Since we're introducing a syntax error, we expect there to be an issue, and this Pull Request to be "unable to merge".

1. In GitHub, open your forked repository, and make sure you're on the 'dev' branch.
  - If you're *not* on the 'dev' branch already, click the grey **Branch: master ˅** or **Branch: staging ˅** button, then select **dev**.


2. Click on `security_groups.tf`.

3. Click the ✏️ **pencil icon**, to the right of the buttons labelled **Raw**, **Blame**, **History**.

4. At the end of the file, add a line that says: `kill_all_humans()`

This directive is not yet supported in Terraform v0.12, and thus will cause an error during the `terraform plan` stage.

5. Click the green **Commit changes** button at the bottom of the page.

6. Click on **Pull requests** in the navigation bar at the top.

7. Click either the green **Compare & pull request** button or the green **New pull request** button.

8. Set:
    - **base repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **head repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **base:** to `staging`
    - **compare:** to `dev`.

9. (Optional) Give your PR a name, and add a description.

10. Click the green **Create pull request** button.

11. Click the green **Create pull request** button again, if necessary.


Now that we have a Pull Request, Terraform Cloud will jump into action and run a `terraform plan` to see if the new code could be deployed.  
This is known as a "speculative plan", and cannot be found through the Terraform Cloud UI, but only by following the link in GitHub. (This often leads to confusion among new users.)

In the "Conversation thread" on the Pull Request page, GitHub will say **Checking for ability to merge automatically** while Terraform Cloud is running the Plan. After the Plan has failed, this message will change to **All checks have failed**.

We can see details about the checks below this message. (Note that "atlas" is the legacy name of Terraform Cloud.)  
To the right of the line that says "Terraform plan errored", you can click on **Details** to see the _speculative plan_.

### 2) Run-time error

In this section, we will introduce an error which does not violate the Terraform syntax, but which will cause issues at run-time (i.e. once the code has been deployed).

Terraform Cloud will again automatically check if this new code could be deployed to the staging environment, and let GitHub know if there is an issue. With this error, Terraform Cloud cannot know that there is a problem, therefore merging into the staging branch will be possible.

However, the GitHub Action we have set up will be able to detect that the staging environment is not reachable, and therefore will
veto merging into the master branch later.

1. In GitHub, open your forked repository, and make sure you're on the 'dev' branch.
  - If you're *not* on the 'dev' branch already, click the grey **Branch: master ˅** or **Branch: staging ˅** button, then select **dev**.


2. Click on `security_groups.tf`.

3. Click the ✏️ **pencil icon**, to the right of the buttons labelled **Raw**, **Blame**, **History**.

4. Remove the line at the end of the file that says: `kill_all_humans()`.  
This was clearly not the way to go about that.

5. In the second `ingress {` block, change the `from_port` and `to_port` directives to a different number, e.g.
```
    from_port   = 20480
    to_port     = 20480
```

6. Click the green **Commit changes** button at the bottom of the page.

7. Click on **Pull requests** in the navigation bar at the top.

8. Click on the existing Pull Request.

You can see that, again Terraform Cloud is running a _speculative plan_ using the code we are attempting to merge into staging. This time the plan should succeed (click **Show all checks** and/or **Details** to see the speculative plan) and we can continue to merge our PR (pull request).  
(You may need to refresh the page if the check does not appear / change automatically.)

9. Click on **Merge pull request**, then **Confirm merge**.

You should see a message that reads "Pull request successfully merged and closed".

If you navigate to the **2048-staging** Workspace in **Terraform Cloud**, you should see a run with name **Merge pull request #…**.  
Terraform Cloud automatically started deploying the new code once the Pull Request was merged. This is a very powerful functionality to keep our code base and our environments in sync.

10. Back on **GitHub**, Click on **Pull requests** in the navigation bar at the top.

11. Click either the green **Compare & pull request** button or the green **New pull request** button.

12. Set:
    - **base repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **head repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **base:** to `master`
    - **compare:** to `staging`.

13. (Optional) Give your PR a name, and add a description.

14. Click the green **Create pull request** button.

15. Click the green **Create pull request** button again, if necessary.

ℹ️ Observe the section about checks. You should see a Terraform Cloud check running on GitHub (as `atlas/<your-tfc-workspace>/2048-prod`), as well as the GitHub Action we set up before (as `prod-PR / staging-healthcheck (pull_request)`).  
(You may need to refresh your page occasionally to see the checks update.)

GitHub should now (after all checks have finished) display the message: **Some checks were not successful**.  Click on **Show all checks** (if shown) for more information.

The culprit seems to be **prod-PR / staging-healthcheck (pull_request)**, and you can click on **Details** to see more.  
You can explore the different automated checks on your own.  


16. When you're done exploring, please click the grey **Close pull request** button at the bottom of the page.


### 3) Successful deploy

In this section, we will introduce an update to our application which does not cause an error.

Terraform Cloud will again automatically check if this new code could be deployed to the staging environment (it can!), and the GitHub Action we have set up will verify that the staging environment is reachable (once we raise a PR into the master branch).  

We will then manually check our staging environment, before merging the tested code from staging (`staging` branch) into production (`master` branch).  
This manual check might be carried out by a team-member with a QA role, who might then approve the PR, before it is merged. The number of 'human' approvals required for a merge can also be specified in GitHub.


1. In GitHub, open your forked repository, and make sure you're on the 'dev' branch.
  - If you're *not* on the 'dev' branch already, click the grey **Branch: master ˅** or **Branch: staging ˅** button, then select **dev**.


2. Click on `security_groups.tf`.

3. Click the ✏️ **pencil icon**, to the right of the buttons labelled **Raw**, **Blame**, **History**.

4. In the second `ingress {` block, change the `from_port` and `to_port` directives back to `2048`, i.e.

```
    from_port   = 2048
    to_port     = 2048
```

5. Click the green **Commit changes** button at the bottom of the page.

6. Click on the name of your repo (between **Branch: dev ˅** and **security_groups.tf**, near the top).
  - Again, make sure you are still on the 'dev' branch.


7. Click on `user-data.sh.tpl`.

8. Click the ✏️ **pencil icon**, to the right of the buttons labelled **Raw**, **Blame**, **History**.

9. Change the Docker image in the last line to `jeffhemmen/2048-pokemon`, so that the last line reads:
```
docker run -d -p 2048:80 jeffhemmen/2048-pokemon
```

10. Click the green **Commit changes** button at the bottom of the page.

11. Click on **Pull requests** in the navigation bar at the top.

12. Click either the green **Compare & pull request** button or the green **New pull request** button.

13. Set:
    - **base repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **head repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **base:** to `staging`
    - **compare:** to `dev`.

14. (Optional) Give your PR a name, and add a description.

15. Click the green **Create pull request** button.

16. Click the green **Create pull request** button again, if necessary.

17. After all checks have passed, click the green **Merge pull request** button, then **Confirm merge**.

You should see a message that reads "Pull request successfully merged and closed".

(If you navigate to the **2048-staging** Workspace in **Terraform Cloud**, you should see a run with name **Merge pull request #...**.  
Again, Terraform Cloud automatically started deploying the new code once the Pull Request was merged.)

ℹ️ This is the stage at which manual Quality Assurance might happen, before a release is merged into 'master' and thus Production. Navigate to the URL of your staging environment and assure yourself that the webapp looks fine. (Again, it may take a few minutes until Terraform Cloud has deployed the new version, and updated DNS records have propagated.)

18. Click on **Pull requests** in the navigation bar at the top.

19. Click either the green **Compare & pull request** button or the green **New pull request** button.

20. Set:
    - **base repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **head repository:** (if shown) to _your_ (forked) repo (**not** `DevOpsPlayground/Hands-on-with-Terraform-Cloud`)
    - **base:** to `master`
    - **compare:** to `staging`.

21. (Optional) Give your PR a name, and add a description.

22. Click the green **Create pull request** button.

23. Click the green **Create pull request** button again, if necessary.

Both the Terraform Cloud check and the GitHub Action should now run, and return successfully.

24. After this, you can click the green **Merge pull request** button, then **Confirm merge**, in order to merge your changes into production with a high level of confidence.

If you navigate to the **2048-prod** Workspace in **Terraform Cloud**, you can see the latest version of our app being deployed to production. Once this is done, you can navigate to the URL output at the end of the Apply in order to see the live app. (Again, DNS propagation might take a minute.)


### Thank you!
You have now reached the hands-on part of this DevOps Playground.

I hope you enjoyed it and learned something new!  
Please don't hesitate to get in touch if you have any feedback or questions about the Playground, or for any other business relating to ECS Digital (it's a really cool place to work!). 🙂

Thanks for coming,  
–Jeff Hemmen \<jeff.hemmen@ecs-digital.co.uk\>

---

### Acknowledgements and Licenses:

I would like to thank the amazing team at ECS Digital for organising all the (boring, to me 😛) stuff around the DPG and allowing me to focus 100% on the tech that I am passionate about!

Also thank you very much to everyone for attending—it would have been rather dull without all of you\!  
Please help yourselves to pizza 🍕+ 🍺 beer in a minute!

The applications deployed in this DevOps Playground are / are based on existing Docker images and GitHub repositories.  
They are:  
* https://hub.docker.com/r/blackicebird/2048
* https://github.com/amschrader/2048

I would like to express my thanks to the creators / maintainers of the above.

[tfc]: https://d3pbgyccvprzn0.cloudfront.net/CIRC-50173-7c18738/assets/terraform-cloud-logo-81769debed7594dfa089baf99d4a402aedadaaf69303482f37fac40d39e7c047.svg
[dpg]: https://secure.meetupstatic.com/photos/event/a/c/7/a/highres_478304154.jpeg
