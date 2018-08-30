<?php

namespace {

    use SilverStripe\CMS\Model\SiteTree;

    class Page extends SiteTree
    {
        private static $db = [];

        private static $has_one = [];

        public static function MyMethod()
        {
            return (1 + 1);
        }
    }
}
