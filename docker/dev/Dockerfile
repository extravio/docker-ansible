FROM php:7.2-apache

MAINTAINER Mikael Mrozik

RUN apt-get -qq update

# Install components
RUN apt-get update -y && apt-get install -y \
        telnet \
        iputils-ping \
        net-tools \
        vim.tiny \
        apt-utils \
        wget \
        sudo \
        curl \
        git-core \
        gzip \
        unzip \
        libcurl4-openssl-dev \
        libgd-dev \
        libjpeg-dev \
        libpng-dev \
        libldap2-dev \
        libtidy-dev \
        libxslt-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        openssh-client \
        libmagickwand-dev \
    --no-install-recommends && \
    curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
    pecl install xdebug && \
    pecl install imagick-3.4.3 && \
    apt-get remove -y libmagickwand-dev && \
    apt-get install -y libmagickwand-6.q16-3 && \
    rm -r /var/lib/apt/lists/*


# Install PHP Extensions
RUN docker-php-ext-configure intl && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr  && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-enable imagick && \
    docker-php-ext-install -j$(nproc) \
        intl \
        gd \
        ldap \
        mysqli \
        pdo \
        pdo_mysql \
        soap \
        tidy \
        xsl \
        zip

# Composer
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Adminer
RUN mkdir /usr/share/adminer && \
    wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php && \
    ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php && \
    echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf && \
    a2enconf adminer.conf

# SilverStripe Apache Configuration

RUN a2enmod rewrite 

RUN service apache2 restart