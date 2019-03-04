-- initialization function
function init (args)
    local needs = {}
    needs["payload"] = tostring(true)
    return needs
end

-- log function
function log2 (x)
    return math.log(x) / math.log(2)
end

-- function to calculate shannons entropy of a given domain name
function entropy (domainName)
    maxEntropy = log2(domainName:len())
    local N, count, sum, i = domainName:len(), {}, 0
    for char = 1, N do
        i = domainName:sub(char, char)
        if count[i] then
            count[i] = count[i] + 1
        else
            count[i] = 1
        end
    end
    for n_i, count_i in pairs(count) do
        sum = sum + count_i / N * log2(count_i / N)
    end
    return -sum, maxEntropy
end

-- function to parse the payload to extract the domain name
function parsePayload (payload)
    fullDomainName = string.match(payload, "%w+.com")
    domainName = string.gsub(fullDomainName, "%.", "")
    return domainName
end

-- main function that drives the matching
function match (args)
    payload = tostring(args["payload"])
    domainName = parsePayload(payload)
    domainEntropy, maxEntropy = entropy(domainName)
    if domainEntropy > 3 and domainEntropy / maxEntropy >= 0.85 then
        return 1
    end
    return 0
end
