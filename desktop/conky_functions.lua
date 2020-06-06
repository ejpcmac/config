-- Variables to keep the state
local connected_interfaces = ''
local mounted_media = ''
local processor = ''
local cpus=-1

-- Shows ethernet interfaces.
function conky_interfaces()
  if tonumber(conky_parse("$updates")) % 2 == 0 then
    local interfaces = ''

    local result = io.popen("ifconfig -a -s | awk '$1 !~ /Iface/ {print $1}' | grep en")
    for line in result:lines() do
      local interface = trim(line)
      interfaces = interfaces .. format_interface(interface)
    end

    result:close()

    connected_interfaces = trim(interfaces)
  end

  return connected_interfaces
end

function format_interface(interface)
  return " ${addrs " .. interface .. "}\n"
    .. "${upspeedgraph " .. interface .. " 20,150 06E9F8 2104FA}${alignr}${downspeedgraph " .. interface .. " 20,150 FFFF00 DD3A21}\n"
    .. " ${upspeed " .. interface .. "}${alignr}${downspeed " .. interface .. "} \n"
    .. "${hr}\n"
end

-- Shows mounted media (+ local ones).
function conky_media()
  if tonumber(conky_parse("$updates")) % 2 == 0 then
    local media = ''

    -- Internal drives
    local devices = {"/", "/boot/efi"}
    for i, path in pairs(devices) do
      media = media .. format_media(path, path)
    end

    -- External drives
    local result = io.popen("lsblk | grep -oE '(/media/.*)$'")
    for line in result:lines() do
      local path = trim(line)
      local name = string.sub(string.sub(path, string.find(path, '/[^/]*$')), 2)
      media = media .. format_media(name, path)
    end

    result:close()

    mounted_media = trim(media)
  end

  return mounted_media
end

function format_media(name, path)
  return name
    .. "${goto 120}${fs_bar 7,80 " .. path .. "}"
    .. "${alignr}${fs_used " .. path .. "}/${fs_size " .. path .. "}"
    .. "\n"
end

-- Shows processor name.
function conky_processor()
  if processor == '' then
    local file = io.popen("lscpu | grep -Po '(?<=Nom de modèle :)(.*)'")
    processor = trim(file:read("*a"))
    file:close()
  end

  return processor
end

-- Shows CPU frequency.
function conky_cpu_frequency()
  local result = io.popen("lscpu | grep -Po '(?<=Vitesse du processeur en MHz :)(.*)'")
  cpu_freq = trim(result:read("*a"))
  result:close()

  return cpu_freq
end

-- Shows CPU usage.
function conky_drawcpus()
  if cpus == -1 then
    local result = io.popen("lscpu -a -p='cpu' | tail -n 1")
    cpus = trim(result:read("*a"))
    result:close()
  end

  local conky_cpus = ''
  for c = 1, tonumber(cpus) do
    if c % 2 ~= 0 then
      conky_cpus = conky_cpus
        .. "${voffset 10}" .. c .. ": "
        .. "${lua_parse format %3.0f ${cpu cpu" .. c .. "}}%  "
        .. "${voffset -10}${cpugraph cpu" .. c .. " 20,80 FFFF00 DD3A21 -t}"
        .. "$alignr"
        .. "${voffset 10}" .. c+1 .. ": "
        .. "${lua_parse format %2.0f ${cpu cpu" .. c .. "}}%  "
        .. "${voffset -10}${cpugraph cpu" .. c+1 .. " 20,80 FFFF00 DD3A21 -t}"
        .. "\n"
    end
  end

  return trim(conky_cpus)
end

-------------
-- Helpers --
-------------

-- Removes whitespaces.
function trim(s)
   return s:gsub("^%s+", ""):gsub("%s+$", "")
end

-- Formats a number in the conky context.
function conky_format(format, number)
  return string.format(format, conky_parse(number))
end
