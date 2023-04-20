state("Lara Croft GO")
{
    int levelIndex : "mono.dll", 0x261110, 0xD10, 0xA8; // ...GameStructure._instance.m_CurrentLevelIndex
    int chapterIndex : "mono.dll", 0x261110, 0xD10, 0xAC; // ...GameStructure._instance.m_CurrentChapterIndex
    int playerPawnAttachedAnimator : 0x012f4868, 0x1D8, 0x4F0, 0xA8, 0x98, 0x970, 0x18, 0x60, 0xC8; // ...GameManager._instance.m_PlayerPawn.m_AttachedObject
}

startup {
    settings.Add("levels", false, "Split on every level, not just chapters");
}

init {
    refreshRate = 20;
}
// LevelsViewController : ViewController : MonoBehaviour 
// LevelsViewController.m_BookScroller.m_BookPageViewItemTemplate.m_BookCamera

start
{
    if (current.chapterIndex == 0 && current.levelIndex == 0)
        return old.playerPawnAttachedAnimator != 0 && current.playerPawnAttachedAnimator == 0;
    return false;
}

update
{
    
}

split {
    if (current.levelIndex != old.levelIndex)
    {
        return (settings["levels"] || current.levelIndex == 0);
    }
}
