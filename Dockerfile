FROM debian:9
MAINTAINER oglop
ARG user=tomato
ARG arch=mips

RUN buildDeps='build-essential net-tools sudo autoconf m4 bison flex g++ libtool sqlite gcc binutils patch bzip2 make gettext unzip zlib1g-dev libc6 gperf automake groff lib32stdc++6 libncurses5 libncurses5-dev gawk gitk zlib1g-dev autopoint shtool autogen mtd-utils gcc-multilib gconf-editor lib32z1-dev pkg-config libssl-dev automake1.11 libxml2-dev intltool libglib2.0-dev libstdc++5 texinfo dos2unix xsltproc libnfnetlink0 libcurl4-openssl-dev libgtk2.0-dev libnotify-dev libevent-dev git re2c texlive libelf1 mc nodejs' \
	&& apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y $buildDeps \
    && apt-get remove -y libicu-dev \

    && apt-get install linux-headers-4.9.0 -y \
    && buildDeps='libelf1:i386 libelf-dev:i386' \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
    && apt-get install -y $buildDeps \

	&& ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata \

    && useradd -ms /bin/bash $user \
    && /usr/sbin/usermod -aG sudo $user \
    && echo $user:$user | /usr/sbin/chpasswd \
    && echo $user ALL=NOPASSWD: ALL > /etc/sudoers.d/${user}sudo


USER $user
WORKDIR /home/$user

RUN git clone https://bitbucket.org/pedro311/freshtomato-$arch.git

ENV PATH="$PATH:/home/$user/freshtomato-$arch/tools/brcm/hndtools-mipsel-linux/bin"
ENV PATH="$PATH:/home/$user/freshtomato-$arch/tools/brcm/hndtools-mipsel-uclibc/bin"
ENV PATH="$PATH:/bin:/sbin:/usr/bin:/usr/X11R6/bin"
