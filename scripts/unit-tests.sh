#!/usr/bin/env bash
./vendor/bin/phpunit app/tests flush=all
./vendor/bin/phpunit --configuration="phpunit.xml"