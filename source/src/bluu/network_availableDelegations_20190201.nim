
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "network-availableDelegations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableDelegationsList_563761 = ref object of OpenApiRestCall_563539
proc url_AvailableDelegationsList_563763(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableDelegations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableDelegationsList_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all of the available subnet delegations for this subscription in this region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the subnet.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563925 = path.getOrDefault("subscriptionId")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "subscriptionId", valid_563925
  var valid_563926 = path.getOrDefault("location")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "location", valid_563926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563927 = query.getOrDefault("api-version")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "api-version", valid_563927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563954: Call_AvailableDelegationsList_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all of the available subnet delegations for this subscription in this region.
  ## 
  let valid = call_563954.validator(path, query, header, formData, body)
  let scheme = call_563954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563954.url(scheme.get, call_563954.host, call_563954.base,
                         call_563954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563954, url, valid)

proc call*(call_564025: Call_AvailableDelegationsList_563761; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## availableDelegationsList
  ## Gets all of the available subnet delegations for this subscription in this region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the subnet.
  var path_564026 = newJObject()
  var query_564028 = newJObject()
  add(query_564028, "api-version", newJString(apiVersion))
  add(path_564026, "subscriptionId", newJString(subscriptionId))
  add(path_564026, "location", newJString(location))
  result = call_564025.call(path_564026, query_564028, nil, nil, nil)

var availableDelegationsList* = Call_AvailableDelegationsList_563761(
    name: "availableDelegationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/availableDelegations",
    validator: validate_AvailableDelegationsList_563762, base: "",
    url: url_AvailableDelegationsList_563763, schemes: {Scheme.Https})
type
  Call_AvailableResourceGroupDelegationsList_564067 = ref object of OpenApiRestCall_563539
proc url_AvailableResourceGroupDelegationsList_564069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/availableDelegations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableResourceGroupDelegationsList_564068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all of the available subnet delegations for this resource group in this region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the domain name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564070 = path.getOrDefault("subscriptionId")
  valid_564070 = validateParameter(valid_564070, JString, required = true,
                                 default = nil)
  if valid_564070 != nil:
    section.add "subscriptionId", valid_564070
  var valid_564071 = path.getOrDefault("location")
  valid_564071 = validateParameter(valid_564071, JString, required = true,
                                 default = nil)
  if valid_564071 != nil:
    section.add "location", valid_564071
  var valid_564072 = path.getOrDefault("resourceGroupName")
  valid_564072 = validateParameter(valid_564072, JString, required = true,
                                 default = nil)
  if valid_564072 != nil:
    section.add "resourceGroupName", valid_564072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564073 = query.getOrDefault("api-version")
  valid_564073 = validateParameter(valid_564073, JString, required = true,
                                 default = nil)
  if valid_564073 != nil:
    section.add "api-version", valid_564073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564074: Call_AvailableResourceGroupDelegationsList_564067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all of the available subnet delegations for this resource group in this region.
  ## 
  let valid = call_564074.validator(path, query, header, formData, body)
  let scheme = call_564074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564074.url(scheme.get, call_564074.host, call_564074.base,
                         call_564074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564074, url, valid)

proc call*(call_564075: Call_AvailableResourceGroupDelegationsList_564067;
          apiVersion: string; subscriptionId: string; location: string;
          resourceGroupName: string): Recallable =
  ## availableResourceGroupDelegationsList
  ## Gets all of the available subnet delegations for this resource group in this region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location of the domain name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564076 = newJObject()
  var query_564077 = newJObject()
  add(query_564077, "api-version", newJString(apiVersion))
  add(path_564076, "subscriptionId", newJString(subscriptionId))
  add(path_564076, "location", newJString(location))
  add(path_564076, "resourceGroupName", newJString(resourceGroupName))
  result = call_564075.call(path_564076, query_564077, nil, nil, nil)

var availableResourceGroupDelegationsList* = Call_AvailableResourceGroupDelegationsList_564067(
    name: "availableResourceGroupDelegationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/locations/{location}/availableDelegations",
    validator: validate_AvailableResourceGroupDelegationsList_564068, base: "",
    url: url_AvailableResourceGroupDelegationsList_564069, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
