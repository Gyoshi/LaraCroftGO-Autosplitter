state("Lara Croft GO")
{
    int levelIndex                  : "mono.dll", 0x261110, 0xD10, 0xA8;                // ...GameStructure._instance.m_CurrentLevelIndex
    int chapterIndex                : "mono.dll", 0x261110, 0xD10, 0xAC;                // ...GameStructure._instance.m_CurrentChapterIndex
    int checkpointIndex             : "mono.dll", 0x261110, 0xD10, 0xB4;                // ...GameStructure._instance.m_CurrentChapterIndex
    int onCursorEvent               : "mono.dll", 0x2645E0, 0x140, 0x298, 0x48, 0x38, 0x58, 0x0, 0x78;      // ...InputManager._instance.OnCursorEvent
    // int playerPawnAttachedAnimator  : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0x60, 0xC8;    // ...GameManager._instance.m_PlayerPawn.m_AttachedObject
    bool isMoveAnimationFinished    : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0x60, 0x40;    // ...GameManager._instance.m_PlayerPawn.m_IsMoveAnimationFinished
    int laraRounds                  : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0xD0;          // ...GameManager._instance.m_LaraRoundsCount
}

startup 
{
    settings.Add("levels", false, "Split on every level, not just chapters");
}

init
{
    vars.finalMove = false;
    vars.inputActiveTime = DateTime.Now;
    vars.startTriggered = false;
}

onStart
{
    vars.finalMove = false;
}

// start
// {
//     // Start 4 seconds after onCursorEvent becomes nonzero. Accuracy seems to vary within about 50ms (3 frames)
//     if (current.chapterIndex == 0 && current.levelIndex == 0)
//     {
//         if (old.onCursorEvent == 0 && current.onCursorEvent != 0)
//         {
//             vars.inputActiveTime = DateTime.Now;
//             vars.startTriggered = true;
//         }

//         if (vars.startTriggered && DateTime.Now >= vars.inputActiveTime.Add(TimeSpan.FromSeconds(4))) 
//         {
//             vars.startTriggered = false;
//             return true;
//         }
//     }
//     return false;
// }

update
{
    // Final split logic
    if (current.chapterIndex == 4 && current.levelIndex == 2 && current.checkpointIndex == 2)
    {
        if (old.laraRounds < current.laraRounds)
            vars.finalMove = true;
    }
    else
    {
        vars.finalMove = false;
    }
}

split 
{
    if (current.levelIndex != old.levelIndex)
    {
        return (settings["levels"] || current.levelIndex == 0);
    }

    // Final split
    if (vars.finalMove)
        return !old.isMoveAnimationFinished && current.isMoveAnimationFinished;
}
