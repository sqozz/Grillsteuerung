// Command definitions (sent to WIPER register)
#define MCP4551_CMD_WRITE	0x00
#define MCP4551_CMD_INC		0x04
#define MCP4551_CMD_DEC		0x08
#define MCP4551_CMD_READ	0x0C

// Control bit definitions (sent to TCON register)
#define MCP4551_TCON_GC_EN	0x100
#define MCP4551_TCON_R0_EN	0x008
#define MCP4551_TCON_A_EN	0x004
#define MCP4551_TCON_W_EN	0x002
#define MCP4551_TCON_B_EN	0x001
#define MCP4551_TCON_ALL_EN	0x1FF

// Register addresses
#define MCP4551_RA_WIPER	0x00
#define MCP4551_RA_TCON		0x40


// Common WIPER values
#define MCP4551_WIPER_MID	0x080
#define MCP4551_WIPER_A		0x100
#define MCP4551_WIPER_B		0x000
