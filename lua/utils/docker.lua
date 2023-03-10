local TERMINAL = require("toggleterm.terminal").Terminal
local Docker = {}


-- lazydocker
local docker_client = TERMINAL:new({
    cmd = "lazydocker",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
})
function Docker.docker_client_toggle()
    docker_client:toggle()
end

-- Docker ctop
local docker_ctop = TERMINAL:new({
    cmd = "ctop",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
})
function Docker.docker_ctop_toggle()
    docker_ctop:toggle()
end

-- Docker dockly
local docker_dockly = TERMINAL:new({
    cmd = "dockly",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
})
function Docker.docker_dockly_toggle()
    docker_dockly:toggle()
end

return Docker
