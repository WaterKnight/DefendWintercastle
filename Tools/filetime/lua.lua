function getFileTime2(fileName)
    alien = require "alien"

    CreateFile = alien.kernel32.CreateFileA
    tmp = alien.buffer(4)
    FILETIME = alien.defstruct{{'dwLowDateTime', 'ulong'}, {'dwHighDateTime', 'ulong'}}
    GetFileTime = alien.kernel32.GetFileTime

    CreateFile:types{ret = "pointer", abi = 'stdcall', 'string', "int", "int", "pointer", "int", "int", "pointer"}
    GetFileTime:types{ret = 'int', abi = 'stdcall', "pointer", "pointer", "pointer", "pointer"}

    hFile = CreateFile(fileName, GENERIC_WRITE, 7, nil, OPEN_EXISTING, 0, nil)

    tmp:set(1, hFile, 'pointer')

    fT = FILETIME:new()

    GetFileTime(hFile, nil, nil, fT())
print(fT)
    return fT
end

-- timetype: 1 - created, 2 - accessed, 3 - modified
function getFileTime(filepath, timetype)
    timetype = timetype or 1
    local alien = require "alien"

    local GENERIC_READ = 0x80000000
    local GENERIC_WRITE = 0x40000000
    local OPEN_EXISTING = 3

    local FILETIME = alien.defstruct {
      { 'dwLowDateTime'  , 'ulong'},
      { 'dwHighDateTime' , 'ulong'}
    }

    local CreateFile = assert(alien.kernel32.CreateFileA)
    CreateFile:types{ret = "pointer", abi = 'stdcall', "string",
        "int", "int", "pointer", "int", "int", "pointer"}
    local CloseHandle = assert(alien.kernel32.CloseHandle)
    CloseHandle:types{ret = 'int', abi = 'stdcall', "pointer"}
    local GetFileTime = assert(alien.kernel32.GetFileTime)
    GetFileTime:types{ret = 'int', abi = 'stdcall', "pointer", "pointer", "pointer", "pointer"}

    local hFile = CreateFile(filepath, GENERIC_READ, 7, nil, OPEN_EXISTING, 0 ,nil)

    -- check for success
    local tmp = alien.buffer(4)
    tmp:set(1, hFile, 'pointer')
    local hnum = tmp:get(1, 'int')
    if hnum == -1 then return nil end

    local fT = FILETIME:new()
    local success
    if timetype == 1 then success = GetFileTime(hFile, fT(), nil, nil)
    elseif timetype == 2 then success = GetFileTime(hFile, nil, fT(), nil)
    else success = GetFileTime(hFile, nil, nil, fT())
    end

    CloseHandle(hFile)

    if not success then return nil end

    local get_unix = alien.Ntdll.RtlTimeToSecondsSince1970
    get_unix:types{ret = 'int', abi = 'stdcall', "pointer", "ref uint"}
    success, timeval = get_unix(fT(), 0)
    if not success then return nil end

    return timeval
end
