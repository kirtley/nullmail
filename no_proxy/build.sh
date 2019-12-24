#!/bin/bash
source ../domain.env
server_name=null.${domain_name}
function write_composer_env_file
{
  cat > .env << EOF
domain_name=${domain_name}
admin_email=${admin_email}
customer_name=${customer_name}
local_registry=${local_registry}
EOF
}
function write_splash_page
{
  cat > index.html << EOF
<html lang="en">
<head>
  <title>NullMail</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.usebootstrap.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdn.usebootstrap.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
  <nav class="navbar">
  </nav>
  <div class="container-fluid">
    <div class="row content">
      <div class="col-sm-1">
      </div>
      <div class="col-sm-10 text-left">
        <div class="jumbotron">
          <h1 class="text-center">@${server_name}</h1>
          <h1 class="text-center">NullMail Mailserver</h1>
          <h2 class="text-center">@${server_name} email addresses are valid email addresses that deliver to a black hole instead of an inbox.</h2>
          <ul><h4>
            <li>Use it to avoid signing up for spam mail that has to be filtered or unsubscribed.</li>
            <li>Use it to avoid being added to marketing lists that will be bought and sold amongst who knows whom.</li>
            <li>Use any recipient name of your choice:
              <ul><b>
                <li>me@${server_name}</li>
                <li>you@${server_name}</li>
                <li>nospam@${server_name}</li>
              </b></ul>
            </li>
          </h4></ul>
        </div>
        <div>
          <p>Copyright Kirtley.io</p>
        </div>
      </div>
      <div class="col-sm-1">
      </div>
      <footer class="container-fluid text-center">
      </footer>
    </div>
  </div>
</body>
</html>
EOF
}
function write_dockerfile
{
  cat > Dockerfile << EOF
FROM ubuntu:16.04
RUN apt update -qq
RUN echo postfix postfix/mailname string ${server_name}| debconf-set-selections \
  && echo postfix postfix/main_mailer_type string 'Internet Site'| debconf-set-selections \
  && apt install -y -qq postfix
RUN sed "s/myhostname = */myhostname = ${server_name}/g" /etc/postfix/main.cf
RUN echo "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination" | tee -a /etc/postfix/main.cf
RUN echo "local_recipient_maps =" | tee -a /etc/postfix/main.cf
EXPOSE 25
CMD ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -F /var/log/mail.log"]
EOF
}
function deploy_application_containers
{
  write_composer_env_file
  write_dockerfile
  export COMPOSE_IGNORE_ORPHANS=True
  docker-compose -p ${customer_name} up -d --build
}

write_splash_page
deploy_application_containers
