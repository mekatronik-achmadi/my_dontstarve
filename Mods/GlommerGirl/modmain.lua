PrefabFiles = 
{
        "statueglommer",
        "glommer",
        "glommerfuel",
        "girlpoop",
        "girlseeds",
        
	"honk",
	"mabel",
}

Assets =
{

	Asset( "IMAGE", "images/saveslot_portraits/honk.tex" ),
	Asset( "ATLAS", "images/saveslot_portraits/honk.xml" ),
    	Asset( "IMAGE", "images/selectscreen_portraits/honk.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/honk.xml" ),
	Asset( "IMAGE", "images/selectscreen_portraits/honk_silho.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/honk_silho.xml" ),
	Asset( "IMAGE", "bigportraits/honk.tex" ),
	Asset( "ATLAS", "bigportraits/honk.xml" ),
	Asset( "IMAGE", "images/map_icons/honk.tex" ),
	Asset( "ATLAS", "images/map_icons/honk.xml" ),	
	
	Asset( "IMAGE", "images/saveslot_portraits/mabel.tex" ),
	Asset( "ATLAS", "images/saveslot_portraits/mabel.xml" ),
	Asset( "IMAGE", "images/selectscreen_portraits/mabel.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/mabel.xml" ),
	Asset( "IMAGE", "images/selectscreen_portraits/mabel_silho.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/mabel_silho.xml" ),
	Asset( "IMAGE", "bigportraits/mabel.tex" ),
	Asset( "ATLAS", "bigportraits/mabel.xml" ),
}

------------------------------------------------------

local TUNING = GLOBAL.TUNING

local GirlDepiction = GetModConfigData("GirlDepiction")

TUNING.GIRL_ICON = "none"
TUNING.GIRL_DEPIC = "none"

if GirlDepiction == "honk" then
	TUNING.GIRL_ICON = "honk.tex"
	TUNING.GIRL_DEPIC = "honk"
elseif GirlDepiction == "wendy" then
	TUNING.GIRL_ICON = "wendy.png"
	TUNING.GIRL_DEPIC = "wendy"        
elseif GirlDepiction == "mabel" then
	TUNING.GIRL_ICON = "wendy.png"
	TUNING.GIRL_DEPIC = "mabel"
end

------------------------------------------------------

local STRINGS = GLOBAL.STRINGS

STRINGS.NAMES.GLOMMER = "Girl"
STRINGS.NAMES.GLOMMERFLOWER = "Girl's Flower"
STRINGS.NAMES.GLOMMERWINGS = "Girl's Wings"
STRINGS.NAMES.STATUEGLOMMER = "Girl's Statue"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMER = "Her beautiful butt makes me eat her poop"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERWINGS = "It's smells good like her poop"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFLOWER.DEAD = "I still remember her beautiful butt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFLOWER.GENERIC = "This flower as beautiful as her butt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEGLOMMER.GENERIC = "This statue will summon her and her beautiful butt"

STRINGS.GIRL_TITLES = "Dirty Girl"
STRINGS.GIRL_DESCRIPTION = "A Dirty but Useful Girl"
STRINGS.GIRL_QUOTES = "\"My beautiful butt makes you eat my poop\""

STRINGS.NAMES.GIRLPOOP = "Girl's Feces"
STRINGS.NAMES.GLOMMERFUEL = "Girl's Poop"
STRINGS.NAMES.GIRLSEEDS = "Girl's Scat"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.GIRLPOOP = "Her butt hole pooping this meal in my mouth"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFUEL = "Her butt hole pooping this sugar my mouth"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GIRLSEEDS = "Her butt hole pooping this snack my mouth"

------------------------------------------------------

STRINGS.CHARACTER_TITLES.honk = STRINGS.GIRL_TITLES
STRINGS.CHARACTER_TITLES.mabel = STRINGS.GIRL_TITLES

STRINGS.CHARACTER_DESCRIPTIONS.honk = STRINGS.GIRL_DESCRIPTION
STRINGS.CHARACTER_DESCRIPTIONS.mabel = STRINGS.GIRL_DESCRIPTION

STRINGS.CHARACTER_QUOTES.honk = STRINGS.GIRL_QUOTES
STRINGS.CHARACTER_QUOTES.mabel = STRINGS.GIRL_QUOTES

STRINGS.CHARACTER_NAMES.honk = "Honoka Kousaka"
STRINGS.CHARACTER_NAMES.honk = "Mabel Pines"

------------------------------------------------------

local CHARACTER_GENDERS = GLOBAL.CHARACTER_GENDERS

table.insert(CHARACTER_GENDERS.FEMALE, "honk")
table.insert(CHARACTER_GENDERS.FEMALE, "mabel")

AddMinimapAtlas("images/map_icons/honk.xml")

AddModCharacter("honk")
AddModCharacter("mabel")

------------------------------------------------------

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES

local eating = State({
	name = "eating",
        tags ={"busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")    
            inst.AnimState:PlayAnimation("quick_eat")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("eating_idle") end),
        },
        
        onexit= function(inst)
            inst.SoundEmitter:KillSound("eating")    
        end,
})

local eating_idle = State({
        name = "eating_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("colic") end),
        },
})

local colic = State({
	name = "colic",
        tags ={"busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hungry")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry","colic")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("colic_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("colic")
        end,
})

local colic_idle = State({
        name = "colic_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("farting") end),
        },
})

local farting = State({
	name = "farting",
        tags ={"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hungry")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mosquito/mosquito_attack","farting")
            inst:PushEvent("farting")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("farting_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("farting")
        end,
})

local farting_idle = State({
        name = "farting_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_try") end),
        },
        
        onexit= function(inst)
        	inst:PushEvent("boy_get_poop")
        end,
})

local poop_try = State({
	name = "poop_try",
        tags ={"busy"},
        onenter = function(inst)   
            inst.AnimState:PlayAnimation("idle_hot_loop")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry","poop_try")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_try_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("poop_try")
        end,
})

local poop_try_idle = State({
        name = "poop_try_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_fart") end),
        },
})

local poop_fart = State({
	name = "poop_fart",
        tags ={"busy"},
        onenter = function(inst)   
            inst.AnimState:PlayAnimation("idle_hot_loop")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mosquito/mosquito_attack","poop_fart")
            inst:PushEvent("farting")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_fart_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("poop_fart")
        end,
})

local poop_fart_idle = State({
        name = "poop_fart_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_try_again") end),
        },
})

local poop_try_again = State({
	name = "poop_try_again",
        tags ={"busy"},
        onenter = function(inst)   
            inst.AnimState:PlayAnimation("idle_hot_loop")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry","poop_try")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_try_again_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("poop_try")
        end,
})

local poop_try_again_idle = State({
        name = "poop_try_again_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("pooping") end),
        },
})

local pooping = State({
	name = "pooping",
        tags ={"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_hot_loop")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_foley","pooping")
            inst:PushEvent("pooping")
        end,

        timeline=
        {
            TimeEvent(120*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("pooping_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("pooping")
        end,
})

local pooping_idle = State({
        name = "pooping_idle",
        tags ={"busy"},
        onenter = function(inst)
                inst.AnimState:PlayAnimation("idle_loop")
        end,
        
        timeline=
        {
            TimeEvent(60*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
        onexit= function(inst)
        	inst:PushEvent("poop_out")
        end,
})

local poop_run = State()

AddStategraphState("shadowmaxwell", eating)
AddStategraphState("shadowmaxwell", eating_idle)
AddStategraphState("shadowmaxwell", colic)
AddStategraphState("shadowmaxwell", colic_idle)
AddStategraphState("shadowmaxwell", farting)
AddStategraphState("shadowmaxwell", farting_idle)
AddStategraphState("shadowmaxwell", poop_try)
AddStategraphState("shadowmaxwell", poop_try_idle)
AddStategraphState("shadowmaxwell", poop_fart)
AddStategraphState("shadowmaxwell", poop_fart_idle)
AddStategraphState("shadowmaxwell", poop_try_again)
AddStategraphState("shadowmaxwell", poop_try_again_idle)
AddStategraphState("shadowmaxwell", pooping)
AddStategraphState("shadowmaxwell", pooping_idle)

------------------------------------------------------

local PlayFootstep = GLOBAL.PlayFootstep

local run_start = State(
        {
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
                inst.components.locomotor:RunForward()
                inst.AnimState:PlayAnimation("run_pre")
                inst.sg.mem.foosteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        timeline=
        {        
            TimeEvent(4*FRAMES, function(inst)
                PlayFootstep(inst)
            end),
        },        
    }
)

local run = State(
        {
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop")
            
        end,
        
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
            end),
            TimeEvent(15*FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
            end),
        },
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
    }
)

local run_stop = State(
        {
    
        name = "run_stop",
        tags = {"canrotate", "idle"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("run_pst")
            inst:PushEvent("girl_cardio")
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
    }
)

AddStategraphState("shadowmaxwell", run_start)
AddStategraphState("shadowmaxwell", run)
AddStategraphState("shadowmaxwell", run_stop)

------------------------------------------------------

local girl_talking = State(
{
        name = "talk",
        tags = {"idle", "talking"},
        
        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            if not noanim then
                inst.AnimState:PlayAnimation("dial_loop", true)
            end
            
            if inst.talksoundoverride then
                 inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
            else
                local sound_name = inst.soundsname or inst.prefab
                local path = inst.talker_path_override or "dontstarve/characters/"
                inst.SoundEmitter:PlaySound(path..sound_name.."/talk_LP", "talk")
            end

            inst.sg:SetTimeout(1.5 + math.random()*.5)
        end,
        
        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("talk")
            inst.sg:GoToState("idle")
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
        
        events=
        {
            EventHandler("donetalking", function(inst) inst.sg:GoToState("idle") end),
        },
    }
)

local girl_talk_event = EventHandler("ontalk", function(inst, data)
        if inst.sg:HasStateTag("idle") then
                if inst.prefab == "wes" then
                        inst.sg:GoToState("mime")
                else
                        inst.sg:GoToState("talk", data.noanim)
                end
        end
end)

AddStategraphState("shadowmaxwell", girl_talking)
AddStategraphEvent("shadowmaxwell",girl_talk_event)

------------------------------------------------------

local boy_get_poop = State({
        name = "boy_get_poop",
        tags = {"idle"},
        onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("idle_hot_pre")
                inst.components.playercontroller:Enable(false)
                inst.components.health:SetInvincible(true)
        end,

        onexit=function(inst)
                inst.components.health:SetInvincible(false)
                inst.components.playercontroller:Enable(true)
        end,
})

local boy_talking = State(
{
        name = "talk",
        tags = {"idle", "talking"},
        
        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            if not noanim then
                inst.AnimState:PlayAnimation("dial_loop", true)
            end
            
            if inst.talksoundoverride then
                 inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
            else
                local sound_name = inst.soundsname or inst.prefab
                local path = inst.talker_path_override or "dontstarve/characters/"
                inst.SoundEmitter:PlaySound(path..sound_name.."/talk_LP", "talk")
            end

            inst.sg:SetTimeout(1.5 + math.random()*.5)
        end,
        
        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("talk")
            if inst:HasTag("get_poop") then
                inst.sg:GoToState("boy_get_poop")
            else
                inst.sg:GoToState("idle")
            end
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
        
        events=
        {
            EventHandler("donetalking", function(inst)
                    if inst:HasTag("get_poop") then
                        inst.sg:GoToState("boy_get_poop")
                    else
                        inst.sg:GoToState("idle")
                    end
            end),
        },
    }
)

AddStategraphState("wilson", boy_talking)
AddStategraphState("wilson", boy_get_poop)
