// Copyright (c) 2026 Neil Colvin. MIT License; see the repository LICENSE.
using NUnit.Framework;
using EaseeChargerClient.LiveTests;

namespace EaseeChargerClient.ProcessorLiveTests;

// Reuse the original assertions and lifecycle; only the processor's required
// read-only suite inventory differs from the optional desktop role scenarios.
[TestFixture, Category("Live"), NonParallelizable]
public sealed class ReadOnlyTests
{
    private readonly LiveReadTests _tests = new();
    [SetUp] public void SetUp()=>_tests.SetUp();
    [TearDown] public void TearDown()=>_tests.TearDown();
    [Test] public Task AccountIsAuthorized()=>_tests.AccountIsAuthorized();
    [Test] public Task SelectedChargerIsAccessible()=>_tests.SelectedChargerIsAccessible();
    [Test] public Task SelectedSiteIsAccessible()=>_tests.SelectedSiteIsAccessible();
    [Test] public Task SchedulesAreReadable()=>_tests.SchedulesAreReadable();
    [Test] public Task OngoingSessionIsReadable()=>_tests.OngoingSessionIsReadable();
    [Test] public Task StreamSuppliesSelectedProductsCurrentState()=>_tests.StreamSuppliesSelectedProductsCurrentState();
}
