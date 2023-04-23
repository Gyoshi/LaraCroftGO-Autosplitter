state("Lara Croft GO")
{
    int levelIndex                  : "mono.dll", 0x261110, 0xD10, 0xA8;                // ...GameStructure._instance.m_CurrentLevelIndex
    int chapterIndex                : "mono.dll", 0x261110, 0xD10, 0xAC;                // ...GameStructure._instance.m_CurrentChapterIndex
    int checkpointIndex             : "mono.dll", 0x261110, 0xD10, 0xB4;                // ...GameStructure._instance.m_CurrentChapterIndex
    int playerPawnAttachedAnimator  : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0x60, 0xC8;    // ...GameManager._instance.m_PlayerPawn.m_AttachedObject
    bool isMoveAnimationFinished    : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0x60, 0x40;    // ...GameManager._instance.m_PlayerPawn.m_IsMoveAnimationFinished
    int LaraRounds                  : 0x012F50C0, 0xA0, 0x0, 0x10, 0x20, 0xD0;          // ...GameManager._instance.m_LaraRoundsCount
}

startup 
{
    settings.Add("levels", false, "Split on every level, not just chapters");
}

init
{
    vars.finalMove = false;
}

onStart
{
    vars.finalMove = false;
}

update
{
    // Final split logic
    if (current.chapterIndex == 4 && current.levelIndex == 2 && current.checkpointIndex == 2)
    {
        if (old.LaraRounds < current.LaraRounds)
            vars.finalMove = true;
    }
    else
    {
        vars.finalMove = false;
    }
}

start
{
    if (current.chapterIndex == 0 && current.levelIndex == 0)
        return old.playerPawnAttachedAnimator != 0 && current.playerPawnAttachedAnimator == 0;
    return false;
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
