using NUnit.Framework;
using Moq;
using MagicFilesLib;
using System.Collections.Generic;

namespace DirectoryExplorer.Tests;

[TestFixture]
public class DirectoryExplorerTests
{
    private Mock<IDirectoryExplorer> _mockExplorer = null!;
    private readonly string _file1 = "file.txt";
    private readonly string _file2 = "file2.txt";

    [OneTimeSetUp]
    public void Init()
    {
        _mockExplorer = new Mock<IDirectoryExplorer>();
        _mockExplorer
            .Setup(x => x.GetFiles(It.IsAny<string>()))
            .Returns(new List<string> { _file1, _file2 });
    }

    [TestCase]
    public void TestGetFiles()
    {
        var explorer = _mockExplorer.Object;
        var files = explorer.GetFiles(@"C:\dummy\path");

        Assert.That(files, Is.Not.Null);
        Assert.That(files.Count, Is.EqualTo(2));
        Assert.That(files, Contains.Item(_file1));
    }
}
