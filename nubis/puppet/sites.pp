nubis::static { 'static':
  servername           => 'static.mozilla.com',
  serveraliases        => [
    'static.allizom.org',
    # For testing
    "static-${project_name}.allizom.org",
    "static-${project_name}.mozilla.com",
  ],
  options              => ['-Indexes'],
  redirectmatch_status => ['200'],
  redirectmatch_regexp => ['^/health$'],
}

nubis::static { 'planet-mozilla':
  servername    => 'planet.mozilla.org',
  serveraliases => [
    'planet.allizom.org',
    # For testing
    "planet-${project_name}.allizom.org",
    "planet-${project_name}.mozilla.org",
  ],
  override      => ['All'],
}

nubis::static { 'planet-de':
  servername    => 'planet.mozilla.de',
  serveraliases => [
    'planet-de.allizom.org',
  ],
  override      => ['All'],
}

nubis::static { 'planet-bugzilla':
  servername    => 'planet.bugzilla.org',
  serveraliases => [
    'planet-bugzilla.allizom.org',
  ],
  override      => ['All'],
}

nubis::static { 'start':
  servername      => 'start.mozilla.org',
  serveraliases   => [
    'start-haul.allizom.org',
    'start-origin.cdn.mozilla.net',
    'start-origin-phx1.cdn.mozilla.net',
    'start-phx1.mozilla.org',
  ],
  custom_fragment => '
    # in case you dont specify a path, send you to en-US
    # triggers if you came in without a subdomain on start.mozilla.org directly
    RedirectMatch ^/$ http://start.mozilla.org/en-US/

    # Firefox actually defaults to locale.start3.mozilla.com/firefox?stuff
    # we try to redirect away from the /firefox, but apparently some things are still busted
    # this is a hack to get them to the proper page, rather than 404
    RedirectMatch ^/([a-z]{2,3}(-[a-zA-Z]{2})?)/firefox http://start.mozilla.org/$1/

    # We also get things like this occasionally (bug 773654, 758910):
    # http://start.mozilla.org/firefox?client=firefox-a&rls=org.mozilla:en-US:official
    # Should redirect these based on the locale in the string
    # mod_alias cant deal with query strings, need to use mod_rewrite
    RewriteEngine on
    RewriteCond %{QUERY_STRING} ^client=firefox-a&rls=org\.mozilla:([a-z]{2,3}(-[a-zA-Z]{2})?):official$
    RewriteRule ^/firefox/?$ http://start.mozilla.org/%1/? [R=301,L]

    # One last shot... redirect plain old /firefox, regardless of query string
    # or locales
    RewriteRule ^/firefox/?$ http://start.mozilla.org/? [R=301,L]

    ExpiresActive On
    ExpiresDefault "access plus 1 month"
    ExpiresByType text/html "access plus 1 week"
  '
}

nubis::static { 'archive':
  servername    => 'website-archive.mozilla.org',
  serveraliases => [
    'website-archive.allizom.org',
    # For testing
    "website-archive-${project_name}.allizom.org",
    "website-archive-${project_name}.mozilla.org",
  ],
}

nubis::static { 'www-archive':
  servername    => 'www-archive.mozilla.org',
  serveraliases => [
    'www-archive.allizom.org',
    # For testing
    "www-archive-${project_name}.allizom.org",
    "www-archive-${project_name}.mozilla.org",
  ],
}

nubis::static { 'bugzilla':
  serveradmin     => 'webmaster@bugzilla.org',
  servername      => 'www.bugzilla.org',
  serveraliases   => [
    'bugzilla.org',
    'bugzilla-haul.allizom.org',
  ],
  directories     => [
    {
      path           => "/data/${project_name}/bugzilla",
      allow_override => 'All',
      options        => ['Indexes', 'FollowSymLinks'],
    },
    {
      path           => '/',
      provider       => 'location',
      allow_override => ['All'],
      options        => ['Indexes', 'FollowSymLinks'],
    },
    {
      path       => "/data/${project_name}/bugzilla/favicon.ico",
      provider   => 'files',
      force_type => 'image/png',
    },
  ],
  custom_fragment => '
    RewriteEngine On

    RewriteRule ^/docs/html(.*)$ /docs/tip/html$1 [R]
    RewriteRule ^/docs/txt(.*)$ /docs/tip/txt$1 [R]
    RewriteRule ^/docs/pdf(.*)$ /docs/tip/pdf$1 [R]
    RewriteRule ^/docs/xml(.*)$ /docs/tip/xml$1 [R]
    RewriteRule ^/docs/pod(.*)$ /docs/tip/html/api$1 [R]
    RewriteRule ^/docs216(.*)$ /docs/2.16$1 [R]
    RewriteRule ^/docs214(.*)$ /docs/2.14$1 [R]
    RewriteRule ^/docs/tip/pod(.*)$ /docs/tip/html/api$1 [R]
    RewriteRule ^/docs/tip/html(.*)$ /docs/tip/en/html$1 [R=301]

    RewriteRule ^/about\.html$ /about/ [R]
    RewriteRule ^/how_to_help\.html$ /developers/how_to_help.html [R]
    RewriteRule ^/reporting_bugs\.html$ /developers/reporting_bugs.html [R]
    RewriteRule ^/roadmap\.html$ /status/roadmap.html [R]
    RewriteRule ^/consulting\.html$ /support/consulting.html [R]
    RewriteRule ^/download\.html$ /download/ [R]
    RewriteRule ^/discussion\.html$ /support/ [R]
    RewriteRule ^/documentation\.html$ /docs/ [R]
    RewriteRule ^/who_we_are\.html$ /developers/ [R]
    RewriteRule ^/developerguide\.html$ /docs/developer.html [R]
    RewriteRule ^/reviewerguide\.html$ /docs/reviewer.html [R]
    RewriteRule ^/queries\.html$ /docs/queries.html [R]
    RewriteRule ^/changes\.html$ /status/changes.html [R]
    RewriteRule ^/status_updates/2004-04-10.html$ /status/2004-07-10.html [R]
    RewriteRule ^/status/2004-04-10.html$ /status/2004-07-10.html [R]
    RewriteRule ^/status_reports/(.*)$ /status/$1 [R]
    RewriteRule ^/status_updates/(.*)$ /status/$1 [R]
    RewriteRule ^/releases/2\.18rc1/(.*)$ /releases/2.18/$1 [R]
    RewriteRule ^/docs/html/stepbystep\.html$ /docs/2.16/html/installing-bugzilla.html [R]
    RewriteRule ^/docs/tip/en/html/faq\.html$ https://wiki.mozilla.org/Bugzilla:FAQ [R]
  '
}

nubis::static { 'tlscanary':
  servername    => 'tlscanary.mozilla.org',
  serveraliases => [
    'tlscanary.allizom.org',
    # For testing
    "tlscanary-${project_name}.allizom.org",
    "tlscanary-${project_name}.mozilla.org",
  ],
}

nubis::static { 'nightly':
  servername    => 'nightly.mozilla.org',
  serveraliases => [
    'nightly.allizom.org',
    'nightly-haul.allizom.org',
  ],
}

nubis::static { 'publicsuffix':
  servername          => 'www.publicsuffix.org',
  serveraliases       => [
    'publicsuffix.org',
    'publicsuffix-haul.allizom.org',
  ],
  headers             => [
  "set X-Nubis-Version ${project_version}",
  "set X-Nubis-Project ${project_name}",
  "set X-Nubis-Build   ${packer_build_name}",
  'set X-Content-Type-Options "nosniff"',
  'set X-XSS-Protection "1; mode=block"',
  'set X-Frame-Options "DENY"',
  'set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"',
  'always set Content-Security-Policy "default-src \'none\'; img-src \'self\'; script-src \'unsafe-inline\'; style-src \'self\'"',
  'set Access-Control-Allow-Origin "*"',
  ],
  use_default_headers => false,
  custom_fragment     => '
    ExpiresActive On
    ExpiresDefault "access plus 1 hour"

    <FilesMatch "\.(dat)$">
        ExpiresActive  On
        ExpiresDefault "access plus 1 week"

        Header set Cache-Control "max-age=604800"
    </FilesMatch>
  '
}

nubis::static { 'trackertest':
  servername    => 'trackertest.org',
  serveraliases => [
    'itsatracker.org',
    'itsatracker.com',
    'itisatracker-haul.allizom.org',
  ],
}

nubis::static { 'seamonkey':
  serveradmin     => 'webmaster@seamonkeyproject.org',
  servername      => 'www.seamonkey-project.org',
  serveraliases   => [
    'www-stage.seamonkey-project.org',
    'seamonkey-project.org',
    'seamonkey-project-haul.allizom.org',
  ],
  # indexes         => ['index.en.html'],
  directories     => [
    {
      path           => "/data/${project_name}/seamonkey",
      allow_override => ['FileInfo', 'Options=All,MultiViews', 'Indexes'],
      options        => ['+FollowSymLinks', '-Indexes', '+MultiViews'],
    },
  ],
  error_documents => [
    {
      'error_code' => '403',
      'document'   => '/404.html'
    },
    {
      'error_code' => '404',
      'document'   => '/404.html'
    },
    {
      'error_code' => '500',
      'document'   => '/500.html'
    }
  ],
  custom_fragment => '
    <LocationMatch ^/[0-9]+\.html$>
        SetEnvIf Referer ^http HasReferer=True
        SetEnvIf Referer ^https?://[^/]+\.mozilla\.com/ RefererIsMoz=True
        Options +IncludesNoExec
        SetHandler server-parsed
    </LocationMatch>

    AddDefaultCharset UTF-8
    AddType image/svg+xml .svg
    AddType application/vnd.mozilla.xul+xml .xul
    AddType text/xml .rdf
    AddType image/x-icon .ico
    AddType text/calendar .ics
    AddType application/vnd.stardivision.impress .sdd
    AddType application/vnd.stardivision.writer .sdw
    AddType application/vnd.stardivision.draw .sda
    AddType application/vnd.stardivision.calc .sdc

    # Redirect permanent / https://www.seamonkey-project.org/
  '
}

nubis::static { 'krakenbenchmark':
  servername    => 'krakenbenchmark.mozilla.org',
  serveraliases => [
    'krakenbenchmark.allizom.org',
  ]
}

###
nubis::static { 'ccadb':
  servername    => 'www.ccadb.org',
  serveraliases => [
    'ccadb.org',
    'ccadb.allizom.org',
  ],
  rewrites      => [
  { # Access html files without the html suffix
    rewrite_cond => [
      '%{CONTEXT_DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f',
      '%{CONTEXT_DOCUMENT_ROOT}/%{REQUEST_FILENAME}.html -f',
    ],
    rewrite_rule => [ '^.+$ %{CONTEXT_DOCUMENT_ROOT}/%{REQUEST_FILENAME}.html [L]' ],
  }
  ]
}

nubis::static { 'firefoxux':
  servername    => 'design.firefox.com',
  serveraliases => [
    'design.allizom.org',
  ],
  headers       => [
    'set Strict-Transport-Security "max-age=63072000"',
    'set X-Frame-Options "SAMEORIGIN"',
  ],
  aliases       => [
    {
      alias => '/icons',
      path  => "/data/${project_name}/firefoxux/icons",
    }
  ],
}

nubis::static { 'iot':
  servername    => 'iot.mozilla.org',
  serveraliases => [
    'iot.allizom.org',
  ]
}

nubis::static { 'getfirebug':
  servername    => 'getfirebug.com',
  serveraliases => [
    'getfirebug.allizom.org',
  ],
  indexes       => [ 'index.php' ],
}

nubis::static { 'mozqa':
  servername    => 'www.mozqa.com',
  serveraliases => [
    'mozqa.com',
    'mozqa.allizom.org',
  ],
  override      => ['All'],
  options       => ['+Indexes', '+FollowSymLinks'],
  rewrites      => [
  { # Redirect to the SSL CA file
    rewrite_rule => [ '^/ca/$ /ca/ssl-md5-mozqa-ca.pem [R]' ],
  },
  { # Send the correct content-type for a CA cert
    rewrite_rule => [ '^/ca/ssl-md5-mozqa-ca.pem$ - [T=application/x-x509-ca-cert]' ],
  },
  ],
}

nubis::static { 'dynamicua':
  servername    => 'dynamicua-origin.cdn.mozilla.net',
  serveraliases => [
    'dynamicua.allizom.org',
  ],
}
