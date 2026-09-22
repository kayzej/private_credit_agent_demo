import vendor_mock


def test_package_importable() -> None:
    assert vendor_mock.__doc__
