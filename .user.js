// disable safebrowsing
user_pref("browser.safebrowsing.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);

// prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);

// datareporting
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.service.firstRun", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("font.name.serif.x-western", "Droid Serif");

// omtc settings
// hangs ?
//user_pref("webgl.force-enabled", true);
//user_pref("layers.acceleration.force-enabled", true)
//user_pref("layers.offmainthreadcomposition.enabled", true)

// network http pipelining
user_pref("network.http.proxy.pipelining, true)
user_pref("network.http.pipelining", true)
user_pref("network.http.pipelining.maxrequests", 10)

// session store interval in ms
user_pref("browser.sessionstore.interval", 300000)

// disabled tracking protection
user_pref("privacy.trackingprotection.enabled, true)

// new tab page tiles are disabled
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.newtabpage.directory.ping", "");
user_pref("browser.newtabpage.directory.source", "data:application/json,{}");

// place cache on tmpfs
user_pref("browser.cache.disk.parent_directory", "/tmp/mozilla/firefox/alex");
