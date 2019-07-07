function eval($item) {
    write-Verbose "Processing $item"
    if( -not $item) {return $null}
    if( $item -is "ScriptBlock" ) {
        return & $item
    }
    return $item
}

Function or {
    [cmdletbinding()]
    param([parameter(ValueFromRemainingArguments)]$args)
    Write-Verbose ($args | out-string)
    if(-not $args){ return $null }
    foreach ($arg in $args){
        $result = eval $arg
        if($result) { return $result }
    }
}
