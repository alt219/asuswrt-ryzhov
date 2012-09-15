asuswrt-ryzhov = ASUS firmware + JFFS + user scripts
==================================

This is a firmware for ASUS RT-N66U/RT-AC66U/RT-N16 routers with and ONLY with two modifications:

 * JFFS partition enabled,
 * with editable user scripts, executed on key system events.


Preamble
-----------------------

I want to use the last Broadcom SDK, shipped with last stock ASUS firmware, like i did with my RT-N16 + wl500g.googlecode.com f\w before. Neither TomatoUSB nor DD-WRT can not provide it. There is great project by Eric Sauvageau at github.com/RMerl/asuswrt-merlin, but there is too many additional features: while stock firmware develops rapidly, supporting all those additional features is a quite complicated task, it's hard not to break something while catching up last ASUS changes. So i'm gonna make my own firmware with blackjack and... well, with blackjack only.

I took Eric's custom user scripts and apply it to last ASUS firmware. No other changes, all additional features can be provided by Entware/Optware services.

I want to thank github.com/RMerl, who's never turns away from my requests and to github.com/theMIROn, who gives me a kick to start this project.


Requirements
-----------------------

A standart compilation environment. For Debian-based distros:

    $ sudo apt-get install bison flex g++ g++-4.4 g++-multilib gawk gcc-multilib gconf gitk lib32z1-dev \
    libncurses5 libncurses5-dev libstdc++6-4.4-dev libtool m4 pkg-config zlib1g-dev

Firmware compilation tested on Ubuntu 12.04 LTS amd64.


Compilation
-----------------------

    $ git clone git://github.com/ryzhovau/asuswrt-ryzhov.git
    $ cd ./asuswrt-ryzhov
    $ ./compile.sh

If all goes well then a *.trx firmware file will be cooked.


Usage
-----------------------

This is an original ASUS firmware with all it' beautiful features and ugly bugs except two things:

 1. /jffs partition, where you can store your custom scripts and additional kernel modules. Without external USB storage this is a only place where your scripts can survive a reboot. To use /jffs partition go to console, type

        $ nvram set jffs2_on=1
        $ nvram set jffs2_format=1
        $ nvram commit

and reboot a router __twice__ (one to formatting jffs partition, next - to mount). 

 2. A few predefined scripts, driven by some
system events:

 * __/jffs/scripts/services-start__ - will be executed after system boots and mounts external drives. A right place for starting external services from Entware/Optware.
 * __/jffs/scripts/services-stop__ - executed at shutdown before external drives unmounts. Gives a chance to shutdown external services gracefully.
 * __/jffs/scripts/firewall-start__ - after firewall rules reapplied. Place custom iptables rules here.
 * __/jffs/scripts/wan-start__ - after WAN is up. 


That it. Feel free to use and to discuss asuswrt-ryzhov firmware here or at www.wl500g.info
