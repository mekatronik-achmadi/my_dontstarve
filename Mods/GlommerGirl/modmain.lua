PrefabFiles = 
{
	"glommer",
}

Assets =
{
	Asset("ATLAS", "images/newslots.xml"),

}

------------------------------------------------------

STRINGS = GLOBAL.STRINGS

STRINGS.NAMES.GLOMMER = "Girl"
STRINGS.NAMES.GLOMMERFLOWER = "Girl's Flower"
STRINGS.NAMES.GLOMMERFUEL = "Girl's Poop"
STRINGS.NAMES.GLOMMERWINGS = "Girl's Wings"
STRINGS.NAMES.STATUEGLOMMER = "Girl's Statue"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMER = "Her beauty makes me eat her poop"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFUEL = "Her poop smells like a flower"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERWINGS = "It's smells good like her poop"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFLOWER.DEAD = "I still remember her beauty"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLOMMERFLOWER.GENERIC = "This flower as beautiful as she is"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEGLOMMER.GENERIC = "This statue will summon her and her beauty"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POOP = "It's like her poop"

------------------------------------------------------

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES

local pooping = State({
	name = "pooping",
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
            EventHandler("animover", function(inst) inst.sg:GoToState("pooping_idle") end),
        },
        
        onexit= function(inst)
            inst.SoundEmitter:KillSound("eating")    
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
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry","farting")
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
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_pre") end),
        },
})

local poop_pre = State({
	name = "poop_pre",
        tags ={"busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hungry")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry","poop_pre")
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
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_pre_idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("poop_pre")
        end,
})

local poop_pre_idle = State({
        name = "poop_pre_idle",
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
})

local poop_try = State({
	name = "poop_try",
        tags ={"busy"},
        onenter = function(inst)   
            inst.AnimState:PlayAnimation("fishing_idle")
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
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_try_again") end),
        },
})

local poop_try_again = State({
	name = "poop_try_again",
        tags ={"busy"},
        onenter = function(inst)   
            inst.AnimState:PlayAnimation("fishing_idle")
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
            EventHandler("animover", function(inst) inst.sg:GoToState("poop_pst") end),
        },
})

local poop_pst = State({
	name = "poop_pst",
        tags ={"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("fishing_idle")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_foley","poop_pst")
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
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
        onexit= function(inst)
        	inst.SoundEmitter:KillSound("poop_pst")
        end,
})

AddStategraphState("shadowmaxwell", pooping)
AddStategraphState("shadowmaxwell", pooping_idle)
AddStategraphState("shadowmaxwell", farting)
AddStategraphState("shadowmaxwell", farting_idle)
AddStategraphState("shadowmaxwell", poop_pre)
AddStategraphState("shadowmaxwell", poop_pre_idle)
AddStategraphState("shadowmaxwell", poop_try)
AddStategraphState("shadowmaxwell", poop_try_idle)
AddStategraphState("shadowmaxwell", poop_try_again)
AddStategraphState("shadowmaxwell", poop_try_again_idle)
AddStategraphState("shadowmaxwell", poop_pst)
