
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-04-01
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
  macServiceName = "network-networkProfile"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkProfilesListAll_563761 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesListAll_563763(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesListAll_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the network profiles in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563925 = path.getOrDefault("subscriptionId")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "subscriptionId", valid_563925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563926 = query.getOrDefault("api-version")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "api-version", valid_563926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563953: Call_NetworkProfilesListAll_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the network profiles in a subscription.
  ## 
  let valid = call_563953.validator(path, query, header, formData, body)
  let scheme = call_563953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563953.url(scheme.get, call_563953.host, call_563953.base,
                         call_563953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563953, url, valid)

proc call*(call_564024: Call_NetworkProfilesListAll_563761; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkProfilesListAll
  ## Gets all the network profiles in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564025 = newJObject()
  var query_564027 = newJObject()
  add(query_564027, "api-version", newJString(apiVersion))
  add(path_564025, "subscriptionId", newJString(subscriptionId))
  result = call_564024.call(path_564025, query_564027, nil, nil, nil)

var networkProfilesListAll* = Call_NetworkProfilesListAll_563761(
    name: "networkProfilesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkProfiles",
    validator: validate_NetworkProfilesListAll_563762, base: "",
    url: url_NetworkProfilesListAll_563763, schemes: {Scheme.Https})
type
  Call_NetworkProfilesList_564066 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesList_564068(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesList_564067(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all network profiles in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564069 = path.getOrDefault("subscriptionId")
  valid_564069 = validateParameter(valid_564069, JString, required = true,
                                 default = nil)
  if valid_564069 != nil:
    section.add "subscriptionId", valid_564069
  var valid_564070 = path.getOrDefault("resourceGroupName")
  valid_564070 = validateParameter(valid_564070, JString, required = true,
                                 default = nil)
  if valid_564070 != nil:
    section.add "resourceGroupName", valid_564070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564071 = query.getOrDefault("api-version")
  valid_564071 = validateParameter(valid_564071, JString, required = true,
                                 default = nil)
  if valid_564071 != nil:
    section.add "api-version", valid_564071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564072: Call_NetworkProfilesList_564066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network profiles in a resource group.
  ## 
  let valid = call_564072.validator(path, query, header, formData, body)
  let scheme = call_564072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564072.url(scheme.get, call_564072.host, call_564072.base,
                         call_564072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564072, url, valid)

proc call*(call_564073: Call_NetworkProfilesList_564066; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## networkProfilesList
  ## Gets all network profiles in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564074 = newJObject()
  var query_564075 = newJObject()
  add(query_564075, "api-version", newJString(apiVersion))
  add(path_564074, "subscriptionId", newJString(subscriptionId))
  add(path_564074, "resourceGroupName", newJString(resourceGroupName))
  result = call_564073.call(path_564074, query_564075, nil, nil, nil)

var networkProfilesList* = Call_NetworkProfilesList_564066(
    name: "networkProfilesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkProfiles",
    validator: validate_NetworkProfilesList_564067, base: "",
    url: url_NetworkProfilesList_564068, schemes: {Scheme.Https})
type
  Call_NetworkProfilesCreateOrUpdate_564089 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesCreateOrUpdate_564091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkProfileName" in path,
        "`networkProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles/"),
               (kind: VariableSegment, value: "networkProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesCreateOrUpdate_564090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a network profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: JString (required)
  ##                     : The name of the network profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  var valid_564120 = path.getOrDefault("networkProfileName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "networkProfileName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update network profile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_NetworkProfilesCreateOrUpdate_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a network profile.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_NetworkProfilesCreateOrUpdate_564089;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          networkProfileName: string; parameters: JsonNode): Recallable =
  ## networkProfilesCreateOrUpdate
  ## Creates or updates a network profile.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: string (required)
  ##                     : The name of the network profile.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update network profile operation.
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  var body_564127 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  add(path_564125, "resourceGroupName", newJString(resourceGroupName))
  add(path_564125, "networkProfileName", newJString(networkProfileName))
  if parameters != nil:
    body_564127 = parameters
  result = call_564124.call(path_564125, query_564126, nil, nil, body_564127)

var networkProfilesCreateOrUpdate* = Call_NetworkProfilesCreateOrUpdate_564089(
    name: "networkProfilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkProfiles/{networkProfileName}",
    validator: validate_NetworkProfilesCreateOrUpdate_564090, base: "",
    url: url_NetworkProfilesCreateOrUpdate_564091, schemes: {Scheme.Https})
type
  Call_NetworkProfilesGet_564076 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesGet_564078(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkProfileName" in path,
        "`networkProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles/"),
               (kind: VariableSegment, value: "networkProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesGet_564077(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified network profile in a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: JString (required)
  ##                     : The name of the public IP prefix.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564080 = path.getOrDefault("subscriptionId")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "subscriptionId", valid_564080
  var valid_564081 = path.getOrDefault("resourceGroupName")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "resourceGroupName", valid_564081
  var valid_564082 = path.getOrDefault("networkProfileName")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "networkProfileName", valid_564082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564083 = query.getOrDefault("api-version")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "api-version", valid_564083
  var valid_564084 = query.getOrDefault("$expand")
  valid_564084 = validateParameter(valid_564084, JString, required = false,
                                 default = nil)
  if valid_564084 != nil:
    section.add "$expand", valid_564084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564085: Call_NetworkProfilesGet_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network profile in a specified resource group.
  ## 
  let valid = call_564085.validator(path, query, header, formData, body)
  let scheme = call_564085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564085.url(scheme.get, call_564085.host, call_564085.base,
                         call_564085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564085, url, valid)

proc call*(call_564086: Call_NetworkProfilesGet_564076; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          networkProfileName: string; Expand: string = ""): Recallable =
  ## networkProfilesGet
  ## Gets the specified network profile in a specified resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: string (required)
  ##                     : The name of the public IP prefix.
  var path_564087 = newJObject()
  var query_564088 = newJObject()
  add(query_564088, "api-version", newJString(apiVersion))
  add(query_564088, "$expand", newJString(Expand))
  add(path_564087, "subscriptionId", newJString(subscriptionId))
  add(path_564087, "resourceGroupName", newJString(resourceGroupName))
  add(path_564087, "networkProfileName", newJString(networkProfileName))
  result = call_564086.call(path_564087, query_564088, nil, nil, nil)

var networkProfilesGet* = Call_NetworkProfilesGet_564076(
    name: "networkProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkProfiles/{networkProfileName}",
    validator: validate_NetworkProfilesGet_564077, base: "",
    url: url_NetworkProfilesGet_564078, schemes: {Scheme.Https})
type
  Call_NetworkProfilesUpdateTags_564139 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesUpdateTags_564141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkProfileName" in path,
        "`networkProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles/"),
               (kind: VariableSegment, value: "networkProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesUpdateTags_564140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates network profile tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: JString (required)
  ##                     : The name of the network profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("networkProfileName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "networkProfileName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update network profile tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_NetworkProfilesUpdateTags_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates network profile tags.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_NetworkProfilesUpdateTags_564139; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          networkProfileName: string; parameters: JsonNode): Recallable =
  ## networkProfilesUpdateTags
  ## Updates network profile tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: string (required)
  ##                     : The name of the network profile.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update network profile tags.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  var body_564151 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  add(path_564149, "networkProfileName", newJString(networkProfileName))
  if parameters != nil:
    body_564151 = parameters
  result = call_564148.call(path_564149, query_564150, nil, nil, body_564151)

var networkProfilesUpdateTags* = Call_NetworkProfilesUpdateTags_564139(
    name: "networkProfilesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkProfiles/{networkProfileName}",
    validator: validate_NetworkProfilesUpdateTags_564140, base: "",
    url: url_NetworkProfilesUpdateTags_564141, schemes: {Scheme.Https})
type
  Call_NetworkProfilesDelete_564128 = ref object of OpenApiRestCall_563539
proc url_NetworkProfilesDelete_564130(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkProfileName" in path,
        "`networkProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkProfiles/"),
               (kind: VariableSegment, value: "networkProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkProfilesDelete_564129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified network profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: JString (required)
  ##                     : The name of the NetworkProfile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  var valid_564133 = path.getOrDefault("networkProfileName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "networkProfileName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_NetworkProfilesDelete_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network profile.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_NetworkProfilesDelete_564128; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          networkProfileName: string): Recallable =
  ## networkProfilesDelete
  ## Deletes the specified network profile.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkProfileName: string (required)
  ##                     : The name of the NetworkProfile.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "networkProfileName", newJString(networkProfileName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var networkProfilesDelete* = Call_NetworkProfilesDelete_564128(
    name: "networkProfilesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkProfiles/{networkProfileName}",
    validator: validate_NetworkProfilesDelete_564129, base: "",
    url: url_NetworkProfilesDelete_564130, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
