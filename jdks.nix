{
    # The hasDefault attribute means there is a default that IS NOT AN ALIAS
    corretto = { hasDefault = false; separator = ""; versions = [ "11" "17" "21" ]; };
    graalvm-ce = { hasDefault = true; separator = "_"; path="graalvmPackages.graalvm-ce"; versions = []; };
    graalvm-oracle = { hasDefault = true; separator = "_"; path="graalvmPackages.graalvm-oracle"; versions = [ "17" ]; };
    openjdk = { hasDefault = true; separator = ""; versions = [ "8" "11" "17" "21" "24" ]; };
    semeru-bin = { hasDefault = true; separator = "-"; versions = [ "11" "17" "21" ]; };
    semeru-jre-bin = { hasDefault = true; separator = "-"; versions = [ "11" "17" "21" ]; };
    temurin-bin = { hasDefault = true; separator = "-"; versions = [ "23" "24" ]; };
    temurin-jre-bin = { hasDefault = true; separator = "-"; versions = [ "11" "17" "21" "23" "24" ]; };
    zulu = { hasDefault = true; separator = ""; versions = [ "8" "11" "17" "21" "24" "25" ]; };
}
