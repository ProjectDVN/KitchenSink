module main;

import dvn;

import core.stdc.stdlib : exit;

version (Windows)
{
	import core.runtime;
	import core.sys.windows.windows;
	import std.string;
	
	pragma(lib, "user32");

	extern (Windows)
	int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				LPSTR lpCmdLine, int nCmdShow)
	{
		int result;

		try
		{
			Runtime.initialize();
			result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
			Runtime.terminate();
		}
		catch (Throwable e) 
		{
			import std.file : write;

			write("errordump.log", e.toString);

			MessageBoxA(null, e.toString().toStringz(), null,
						MB_ICONEXCLAMATION);
			exit(0);
			result = 0;     // failed
		}

		return result;
	}

	int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				LPSTR lpCmdLine, int nCmdShow)
	{
		mainEx();
		return 0;
	}
}
else
{
	void main()
	{
		try
		{
			mainEx();
		}
		catch (Throwable e)
		{
			import std.stdio : writeln, readln;
			import std.file : write;

			write("errordump.log", e.toString);
			
			writeln(e);

			exit(0);
		}
	}
}

public final class Events : DvnEvents
{
	public:
	final:
	// override events here ...
	private Panel dialoguePanel;

	override void renderGameViewDialoguePanel(Panel panel)
	{
		dialoguePanel = panel;

		auto window = panel.window;

		panel.position = IntVector(16, panel.y);

		panel.size = IntVector(
			(window.width / 100) * 97,
			panel.height
		);
	}

	private Button saveButton;

	override void renderGameViewSaveButton(Button button)
	{
		saveButton = button;

		button.fontName = "FontAwesome";
		button.text = "\uf0c7";

		button.size = IntVector(70, button.height);
		button.position = IntVector(
			dialoguePanel.x + dialoguePanel.width + 16,
			dialoguePanel.y
		);
	}
	
	override void renderGameViewExitButton(Button button)
	{
		auto window = button.window;
		button.position = IntVector(window.width - (button.width + 16), 16);

		button.fontName = "FontAwesome";
		button.text = "\uf00d";
	}
	
	override void renderGameViewSettingsButton(Button button)
	{
		button.size = IntVector(saveButton.width, button.height);

		button.fontName = "FontAwesome";
		button.text = "\uf013";
	}

	override void renderGameViewAutoButton(Button button)
	{
		button.size = IntVector(saveButton.width, button.height);
	}
}

void mainEx()
{
	DvnEvents.setEvents(new Events);

	runDVN();
}
