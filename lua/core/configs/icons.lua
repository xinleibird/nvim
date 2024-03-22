local M = {}
M.lspkind = {
  Alias = "",
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Fragment = "󰅴",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Macro = "󰉺",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

M.diagnostics = {
  Hint = "",
  Info = "",
  Warning = "",
  Error = "",
}

M.ui = {
  File = "󰈚",
  FileOutline = "󰧭",
  FileSymlink = "",
  Folder = "󰉋",
  FolderEmpty = "󰉖",
  FolderOpen = "󰝰",
  FolderEmptyOpen = "󰷏",
  FolderSymlink = "",
  FolderSymlinkOpen = "",
  ArrowOpen = "",
  ArrowClosed = "",
  ChevronDown = "",
  ChevronRight = "",
  ChevronLeft = "",
  ChevronUp = "",
  Close = "󰅖",
  CloseBold = "",
  Modified = "",
  ArrowLeft = "",
  ArrowRight = "",
  Clock = "",
  DockLeft = "󱂪",
  DockRight = "󱂫",
  DockTop = "󱔓",
  DockBottom = "󱂩",
  Pending = "",
  Checked = "",
  Unchecked = "",
  Ghost = "󰊠",
  GhostOutline = "󱙝",
  Jellyfish = "󰼁",
  JellyfishOutline = "󰼂",
  SeparatorLeft = "",
  SeparatorRight = "",
  Search = "",
  Thumb = "",
  ThumbOutline = "",
  Check = "✓",
  CheckBold = "",
  Branch = "",
  Lock = "󰌾",
  LockOutline = "󰍁",
  GitCompare = "",
  Bug = "󰃤",
  BugOutline = "󰨰",
  Protocol = "󰿘",
  Formatter = "󰦏",
  Linter = "",
  Path = "",
  GitFolderSign = "",
}

M.git = {
  Unstaged = "󰎂",
  Staged = "✓",
  Unmerged = "=",
  Renamed = "󰁔",
  Untracked = "󰐕",
  Deleted = "✗",
  Ignored = "󰛐",

  LineAdded = "",
  LineModified = "",
  LineRemoved = "",
}

M.devicons = {
  [".prettierrc"] = {
    icon = "󰰙",
    color = "#4285F4",
    cterm_color = "33",
    name = "PrettierConfig",
  },
}

return M
