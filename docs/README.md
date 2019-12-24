# NullMail Mailserver
# @null.{domain_name}

## @null.{domain_name} email addresses are valid email addresses that deliver to a black hole instead of an inbox.
  - Use it to avoid signing up for spam mail that has to be filtered or unsubscribed.
  - Use it to avoid being added to marketing lists that will be bought and sold amongst who knows whom.
  - Use any recipient name of your choice:
      - me@{server_name}
      - you@{server_name}
      - nospam@{server_name}

## Ready to go docker project
  1. configure domain.env with your settings
  2. choose proxy or no_proxy
  3. ./build.sh
  4. Add the following DNS records

    - A	 null	         {public_ip_address}	Automatic
    - MX	{domain_name}  10 null.{domain_name}.	Automatic
    - TXT	{domain_name}  "v=spf1 mx a a:null.{domain_name} ip4:{public_ip_address} ?all"
    - TXT	_DMARC	       "v=DMARC1; p=none; rua=mailto:{admin_email}"
